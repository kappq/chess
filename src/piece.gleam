import color.{type Color}
import piece_type.{type PieceType}

pub type Piece {
  Piece(piece_type: PieceType, color: Color)
}
