import gleam/io
import board.{create_board}
import move_generation.{generate_moves}

pub fn main() {
  let board = create_board()
  let moves = generate_moves(board)
  io.debug(moves)
}
