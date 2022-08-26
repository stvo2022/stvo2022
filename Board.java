package MyChess;



import java.util.ArrayList;

class Board {

	ArrayList<Pieces> data = new ArrayList<Pieces>();

	public ArrayList<Pieces> getBoard() {
		return data;
	}

	public void setBoard(ArrayList<Pieces> board) {
		this.data = board;
	}


}