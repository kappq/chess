import gleam/dict
import gleam/int.{bitwise_and}
import gleam/list
import gleam/option.{None, Some}
import bitboard.{type Bitboard, north_one, pop_ls1b, south_one}
import board.{type Board, get_empty}
import color.{Black, White}
import move.{type Move, Move}
import piece.{type Piece, Piece}
// import piece_type.{Bishop, King, Knight, Pawn, Queen, Rook}
import piece_type.{Pawn}

const north: Int = 8

const south: Int = -8

const rank4 = 0x00000000FF000000

const rank5 = 0x000000FF00000000

pub fn parse_moves(to_bitboard: Bitboard, movement: Int) -> List(Move) {
  parse_moves_loop(to_bitboard, movement, [])
}

fn parse_moves_loop(
  to_bitboard: Bitboard,
  movement: Int,
  moves: List(Move),
) -> List(Move) {
  case pop_ls1b(to_bitboard) {
    None -> []
    Some(square) -> {
      let moves = [Move(square - movement, square), ..moves]
      parse_moves_loop(to_bitboard, movement, moves)
      |> list.append(moves)
    }
  }
}

pub fn generate_moves(board: Board) -> List(Move) {
  board.pieces
  |> dict.to_list()
  |> list.flat_map(fn(entry) {
    let #(piece, bitboard) = entry
    case piece {
      Piece(White, Pawn) -> generate_white_pawn_moves(board, bitboard)
      Piece(Black, Pawn) -> generate_black_pawn_moves(board, bitboard)
      // Piece(_, Knight) -> generate_knight_moves(board, bitboard)
      // Piece(_, Bishop) -> generate_bishop_moves(board, bitboard)
      // Piece(_, Rook) -> generate_rook_moves(board, bitboard)
      // Piece(_, Queen) -> generate_queen_moves(board, bitboard)
      // Piece(_, King) -> generate_king_moves(board, bitboard)
      _ -> todo
    }
  })
}

fn generate_white_pawn_moves(board: Board, bitboard: Bitboard) -> List(Move) {
  let empty = get_empty(board)

  let single_push_targets =
    north_one(bitboard)
    |> bitwise_and(empty)
  let double_push_targets =
    north_one(single_push_targets)
    |> bitwise_and(empty)
    |> bitwise_and(rank4)

  let single_push_moves = parse_moves(single_push_targets, north)
  let double_push_moves = parse_moves(double_push_targets, north * 2)
  list.append(single_push_moves, double_push_moves)
}

fn generate_black_pawn_moves(board: Board, bitboard: Bitboard) -> List(Move) {
  let empty = get_empty(board)

  let single_push_targets =
    south_one(bitboard)
    |> bitwise_and(empty)
  let double_push_targets =
    south_one(single_push_targets)
    |> bitwise_and(empty)
    |> bitwise_and(rank5)

  let single_push_moves = parse_moves(single_push_targets, south)
  let double_push_moves = parse_moves(double_push_targets, south * 2)
  list.append(single_push_moves, double_push_moves)
}
// fn generate_knight_moves(board: Board, bitboard: Bitboard) -> List(Move) {
//   todo
// }
//
// fn generate_bishop_moves(board: Board, bitboard: Bitboard) -> List(Move) {
//   todo
// }
//
// fn generate_rook_moves(board: Board, bitboard: Bitboard) -> List(Move) {
//   todo
// }
//
// fn generate_queen_moves(board: Board, bitboard: Bitboard) -> List(Move) {
//   todo
// }
//
// fn generate_king_moves(board: Board, bitboard: Bitboard) -> List(Move) {
//   todo
// }
