import gleam/int.{
  bitwise_and, bitwise_not, bitwise_shift_left, bitwise_shift_right,
}
import gleam/option.{type Option, None, Some}
import square.{type Square}
import move.{type Move, Move}
import gleam/list

const not_a_file: Bitboard = 0xfefefefefefefefe

const not_h_file: Bitboard = 0x7f7f7f7f7f7f7f7f

/// A 64-bit Int
pub type Bitboard =
  Int

pub fn bitboard_not(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_not()
  |> bitwise_and(0xffffffffffffffff)
}

pub fn get_bit(bitboard: Bitboard, square: Square) -> Int {
  bitboard
  |> bitwise_shift_right(square)
  |> bitwise_and(1)
}

pub fn pop_bit(bitboard: Bitboard, square: Square) -> Bitboard {
  1
  |> bitwise_shift_left(square)
  |> bitwise_not()
  |> bitwise_and(bitboard)
}

pub fn get_lsb(bitboard: Bitboard) -> Option(Square) {
  case bitboard, get_bit(bitboard, 0) {
    0, _ -> None
    _, 1 -> Some(0)
    _, 0 -> {
      let bitboard = bitwise_shift_right(bitboard, 1)
      get_lsb(bitboard)
      |> option.map(fn(square) { square + 1 })
    }
    _, _ -> panic as "A bit can only be 0 or 1"
  }
}

/// Parse moves accepts a bitboard which represents all the target squares
/// and an offset which represents the movement that it took to get there.
pub fn parse_moves(bitboard: Bitboard, offset: Int) -> List(Move) {
  bitboard
  |> get_ones()
  |> list.map(fn(square) { Move(square - offset, square) })
}

fn get_ones(bitboard: Bitboard) -> List(Square) {
  case get_lsb(bitboard) {
    None -> []
    Some(square) -> {
      let bitboard = pop_bit(bitboard, square)
      [square, ..get_ones(bitboard)]
    }
  }
}

pub fn north_one(bitboard: Bitboard) {
  bitboard
  |> bitwise_shift_left(8)
}

pub fn south_one(bitboard: Bitboard) {
  bitboard
  |> bitwise_shift_right(8)
}

pub fn east_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_left(1)
  |> bitwise_and(not_a_file)
}

pub fn north_east_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_left(9)
  |> bitwise_and(not_a_file)
}

pub fn south_east_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_right(7)
  |> bitwise_and(not_a_file)
}

pub fn west_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_right(1)
  |> bitwise_and(not_h_file)
}

pub fn north_west_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_left(7)
  |> bitwise_and(not_h_file)
}

pub fn south_west_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_right(9)
  |> bitwise_and(not_h_file)
}
