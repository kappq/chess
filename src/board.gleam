import gleam/dict.{type Dict}
import gleam/int.{bitwise_or}
import gleam/list
import bitboard.{type Bitboard, bitboard_not}
import color.{type Color, Black, White}
import piece.{type Piece, Piece}
import piece_type.{Pawn}

pub type Board {
  Board(pieces: Dict(Piece, Bitboard), side_to_move: Color)
}

pub fn create_board() -> Board {
  let pieces =
    dict.new()
    |> dict.insert(Piece(White, Pawn), 0x20000000080400)
    |> dict.insert(Piece(Black, Pawn), 0x8000000000000)
  let side_to_move = White

  Board(pieces, side_to_move)
}

pub fn get_color_occupied(board: Board, color: Color) -> Bitboard {
  board.pieces
  |> dict.filter(fn(piece, _) { piece.color == color })
  |> dict.values()
  |> list.fold(0, fn(occupied, bitboard) { bitwise_or(occupied, bitboard) })
}

pub fn get_occupied(board: Board) -> Bitboard {
  let white_occupancies = get_color_occupied(board, White)
  let black_occupancies = get_color_occupied(board, Black)
  bitwise_or(white_occupancies, black_occupancies)
}

pub fn get_empty(board: Board) -> Bitboard {
  board
  |> get_occupied()
  |> bitboard_not()
}
