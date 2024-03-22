import board.{create_board}
import move_generation.{generate_moves}

pub fn main() {
  let board = create_board()
  generate_moves(board)
}
