package MyChess;


import java.awt.Image;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.ArrayList;


class PiecesDragDropListener implements MouseListener, MouseMotionListener {

	static Pieces pieces = new Pieces();
		
	private ChessGui chessGui;
	private Piece dragPiece;
	private Piece oponentPiece;
	private int dragOffsetX;
	private int dragOffsetY;
	
	Board board  = new Board();
	
	
	@SuppressWarnings("static-access")
	PiecesDragDropListener(Pieces pieces, ChessGui chessGui) {
		this.pieces = pieces;
		this.chessGui = chessGui;
		addMoves();
		//print ();
	}

	public void mousePressed(MouseEvent evt) {
		int x = evt.getPoint().x;
		int y = evt.getPoint().y;

		//System.out.println("MousePressed");
		ArrayList<Piece> pp = pieces.getPieces();		
		for (int n = 0; n < pp.size(); n++) {
			Piece piece = pp.get(n);		
			if (mouseOverPiece(piece, x, y)) {
				this.dragOffsetX = x - piece.getX();
				this.dragOffsetY = y - piece.getY();
				this.dragPiece = piece;
				break;
			}
		}

		// move drag piece to the top of the list
		if (this.dragPiece != null) {
			//System.out.println("removed................");
		}
		
	}

	
	private boolean mouseOverPiece(Piece piece, int x, int y) {
		int x1 = piece.getX();
		int y1 = piece.getY();
		int w = piece.getWidth();
		int h = piece.getHeight();

		if (x >= x1 & x <= (x1 + w) && y >= y1 && y <= (y1 + h)) {

			return true;
		}

		else
			return false;

	}


	public void mouseReleased(MouseEvent evt) {

		int x = evt.getPoint().x;
		int y = evt.getPoint().y;
	
		//System.out.println("MouseReleased....");
		ArrayList<Piece> pp = pieces.getPieces();		
		for (int n = 0; n < pp.size(); n++) {
			Piece piece = pp.get(n);
			if (mouseOverPiece(piece, x, y)) {
				if (piece.equals(dragPiece)) continue;				
				this.oponentPiece = new Piece(piece);				
				pieces.remove(piece);
				this.oponentPiece.setX(20);
				this.oponentPiece.setY(530);				
				pieces.getDeadpieces().add(this.oponentPiece);
				break;
			}
		}
	
		if (this.dragPiece != null) {
			pieces.mpieces.remove(this.dragPiece);
			pieces.mpieces.add(this.dragPiece);				
		}

		this.dragPiece = null;
		this.oponentPiece = null;
		this.chessGui.repaint();
		
		addMoves(); // Add current pieces to board
		
		//print ();
		
		
	}
	
	public void reDraw () throws IOException {
		
		pieces.mpieces.clear();		
		board.getBoard().clear();
		pieces.getDeadpieces().clear();
		pieces.getPieces().clear();
		this.chessGui.draw();
		addMoves();
		this.chessGui.repaint();

	}
	
	public void print() {
		//System.out.println("board size:" + board.data.size());
		for (int n = 0; n < board.data.size(); n++) {
			Pieces p = board.getBoard().get(n);
			ArrayList<Piece> tst =  p.getPieces();
			//System.out.println("....." + tst.size());
		}
	}

	public void undoMoves() {

		int moves = board.data.size(); // size = 1 by default 
		
		
		if (moves < 2  ) return;		
	
		Pieces prevPieces = board.getBoard().get(moves -2); 		
		board.getBoard().remove(moves-1); // remove last move		
		
		pieces.getDeadpieces().clear();
		pieces.getPieces().clear();
		for (Piece piece: prevPieces.getPieces()) {			
			Piece p = new Piece(piece);			
			pieces.add(p);			
		}
		for (Piece piece: prevPieces.getDeadpieces()) {			
			Piece p = new Piece(piece);
			pieces.addDeadPiece(p);
		}

		this.chessGui.repaint();
	
		
	}
	
	public void begin(Pieces oPieces ) {
		
		pieces.mpieces.clear();		
		board.getBoard().clear();
		pieces.getDeadpieces().clear();
		pieces.getPieces().clear();
		for (Piece piece: oPieces.getPieces()) {			
			Piece p = new Piece(piece);
			pieces.add(p);			
		}
		addMoves();
		this.chessGui.repaint();
		
	}

	public void addMoves() {
		Pieces tmp = new Pieces();
		int size;
		size = pieces.getPieces().size();
		for (int n = 0; n < size; n++) {
			Piece piece = new Piece(pieces.getPieces().get(n));
			tmp.add(piece);
		}

		size = pieces.getDeadpieces().size();
		for (int n = 0; n < size; n++) {
			Piece piece = new Piece(pieces.getDeadpieces().get(n));
			tmp.addDeadPiece(piece);
		}

		board.getBoard().add(tmp);
	}
	
	
	public void mouseDragged(MouseEvent evt) {
		
		
		if ( evt.getPoint().x < 115 || evt.getPoint().x > chessGui.board_size + 100) {
			return;
		}
		if ( evt.getPoint().y < 115 || evt.getPoint().y > chessGui.board_size + 100) {
			return;			
		}
		if (this.dragPiece != null) {
			this.dragPiece.setX(evt.getPoint().x - this.dragOffsetX);
			this.dragPiece.setY(evt.getPoint().y - this.dragOffsetY);
			this.chessGui.repaint();
		}

	}

	
	
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub
		// System.out.println("MouseClicked....");

	}

	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub
		// System.out.println("MouseEnter....");
	}


	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		// System.out.println("MouseExited....");

	}

	@Override
	public void mouseMoved(MouseEvent e) {
		// TODO Auto-generated method stub

	}

	
}