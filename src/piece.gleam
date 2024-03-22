import color.{type Color}
import piece_type.{type PieceType}

pub type Piece {
  Piece(color: Color, piece_type: PieceType)
}
