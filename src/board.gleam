import gleam/dict.{type Dict}
import gleam/int.{bitwise_and, bitwise_not, bitwise_or}
import gleam/list
import bitboard.{type Bitboard}
import color.{type Color, Black, White}
import piece.{type Piece, Piece}

pub type Board {
  Board(pieces: Dict(Piece, Bitboard))
}

pub fn create_board() -> Board {
  Board(dict.new())
}

pub fn get_color_occupied(board: Board, color: Color) -> Bitboard {
  board.pieces
  |> dict.filter(fn(piece, _) { piece.color == color })
  |> dict.values()
  |> list.fold(0, fn(empty, bitboard) { bitwise_and(empty, bitboard) })
}

pub fn get_occupied(board: Board) -> Bitboard {
  let white_occupancies = get_color_occupied(board, White)
  let black_occupancies = get_color_occupied(board, Black)
  bitwise_or(white_occupancies, black_occupancies)
}

pub fn get_empty(board: Board) -> Bitboard {
  let occupied = get_occupied(board)
  bitwise_not(occupied)
}
