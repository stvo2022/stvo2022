package MyChess;
import java.util.ArrayList;


public class Pieces {
	
	ArrayList<Piece> mpieces = new ArrayList<Piece>();
	ArrayList<Piece> mdeadpieces = new ArrayList<Piece>();
	
	Pieces (Pieces p) {		
		mpieces = p.mpieces;
		mdeadpieces = p.mdeadpieces;
	}
	
	Pieces () {
	
	}

	
	public void setPieces( Pieces p) {
		mpieces = p.mpieces;
		mdeadpieces = p.mdeadpieces;
	}
	public ArrayList<Piece> getPieces() {
		return mpieces;
	}
	public void setPieces(ArrayList<Piece> pieces) {
		this.mpieces = pieces;
	}
	public ArrayList<Piece> getDeadpieces() {
		return mdeadpieces;
	}
	public void setDeadpieces(ArrayList<Piece> deadpieces) {
		this.mdeadpieces = deadpieces;
	}
	
	public void add(Piece piece) {
		mpieces.add(piece);
		
	}
	public void remove(Piece piece) {
		mpieces.remove(piece);
		
	}
	public void addDeadPiece(Piece piece) {
		mdeadpieces.add(piece);
		
	}
	public void removeDeadPice(Piece piece) {
		mdeadpieces.remove(piece);
		
	}
	
	
}
