import gleam/int.{
  bitwise_and, bitwise_not, bitwise_shift_left, bitwise_shift_right,
}
import gleam/option.{type Option, None, Some}
import square.{type Square}

const north: Int = 8

const south: Int = -8

const east: Int = 1

const north_east: Int = 9

const south_east: Int = -7

const west: Int = -1

const north_west: Int = 7

const south_west: Int = -9

const not_a_file: Bitboard = 0xfefefefefefefefe

const not_h_file: Bitboard = 0x7f7f7f7f7f7f7f7f

/// A 64-bit Int
pub type Bitboard =
  Int

pub fn north_one(bitboard: Bitboard) {
  bitboard
  |> bitwise_shift_left(north)
}

pub fn south_one(bitboard: Bitboard) {
  bitboard
  |> bitwise_shift_right(south)
}

pub fn east_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_left(east)
  |> bitwise_and(not_a_file)
}

pub fn north_east_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_left(north_east)
  |> bitwise_and(not_a_file)
}

pub fn south_east_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_right(south_east)
  |> bitwise_and(not_a_file)
}

pub fn west_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_right(west)
  |> bitwise_and(not_h_file)
}

pub fn north_west_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_left(north_west)
  |> bitwise_and(not_h_file)
}

pub fn south_west_one(bitboard: Bitboard) -> Bitboard {
  bitboard
  |> bitwise_shift_right(south_west)
  |> bitwise_and(not_h_file)
}

pub fn pop_bit(bitboard: Bitboard, square: Square) -> Bitboard {
  1
  |> bitwise_shift_left(square)
  |> bitwise_not()
  |> bitwise_and(bitboard)
}

pub fn pop_ls1b(bitboard: Bitboard) -> Option(Square) {
  pop_ls1b_loop(bitboard, 0)
}

fn pop_ls1b_loop(bitboard: Bitboard, square: Square) -> Option(Square) {
  let lsb = bitwise_and(bitboard, 1)
  case bitboard {
    0 -> None
    _ if lsb == 1 -> Some(square)
    _ -> {
      let bitboard = bitwise_shift_right(bitboard, 1)
      let square = square + 1
      pop_ls1b_loop(bitboard, square)
    }
  }
}
