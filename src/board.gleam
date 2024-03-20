import gleam/dict.{type Dict}
import bitboard.{type Bitboard}
import piece_type.{type PieceType}

pub type Board {
  Board(pieces: Dict(PieceType, Bitboard))
}
