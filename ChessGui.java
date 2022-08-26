package MyChess;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import javax.imageio.ImageIO;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;

public class ChessGui extends JPanel {

	private static final long serialVersionUID = 1L;
	private static final int COLOR_WHITE = 0;
	private static final int COLOR_BLACK = 1;
	private static final int BISHOP = 1;
	private static final int ROOK = 2;
	private static final int KING = 3;
	private static final int KNIGHT = 4;
	private static final int PAWN = 5;
	private static final int QUEEN = 6;

	static boolean gStart = true;

	static int piece_size = 100;
	static int chess_size = 36;

	static JMenu gMenu;

	int half_piece_size;

	int xoffset = 100;

	int yoffset = 100;

	int x_start = 105;

	int y_start = 105;

	int board_size;

	int ypos;

	static BufferedImage img = null;

	Pieces pieces = new Pieces();

	static Pieces orgPieces = new Pieces();

	static PiecesDragDropListener listener;

	ChessGui() throws IOException {

		draw();

		listener = new PiecesDragDropListener(this.pieces, this);

		this.addMouseListener(listener);
		this.addMouseMotionListener(listener);

	}

	public void draw() throws IOException {

		pieces.getPieces().clear();
		pieces.getDeadpieces().clear();

		orgPieces.getPieces().clear();
		orgPieces.getDeadpieces().clear();

		if (chess_size == 36) {
			piece_size = 100;
			xoffset = 170;
			yoffset = 170;
			x_start = 175;
			y_start = 175;
		} else if (chess_size == 42) {
			piece_size = 110;
			xoffset = 170;
			yoffset = 170;
			x_start = 175;
			y_start = 175;
		} else if (chess_size == 48) {
			piece_size = 120;
			xoffset = 160;
			yoffset = 160;
			x_start = 165;
			y_start = 165;
		} else if (chess_size == 54) {
			piece_size = 130;
			xoffset = 140;
			yoffset = 140;
			x_start = 145;
			y_start = 145;
		} else if (chess_size == 60) {
			piece_size = 140;
			xoffset = 130;
			yoffset = 130;
			x_start = 135;
			y_start = 135;
		} else {
			piece_size = 100;
		}

		board_size = (piece_size) * 4;
		ypos = (piece_size / 2) * 7;
		half_piece_size = (piece_size / 2);

		createPiece(COLOR_WHITE, ROOK, x_start + half_piece_size * 0, y_start);

		createPiece(COLOR_WHITE, KNIGHT, x_start + half_piece_size * 1, y_start);

		createPiece(COLOR_WHITE, BISHOP, x_start + half_piece_size * 2, y_start);

		createPiece(COLOR_WHITE, KING, x_start + half_piece_size * 3, y_start);

		createPiece(COLOR_WHITE, QUEEN, x_start + half_piece_size * 4, y_start);

		createPiece(COLOR_WHITE, BISHOP, x_start + half_piece_size * 5, y_start);

		createPiece(COLOR_WHITE, KNIGHT, x_start + half_piece_size * 6, y_start);

		createPiece(COLOR_WHITE, ROOK, x_start + half_piece_size * 7, y_start);

		for (int i = 0; i < 8; i++) {
			createPiece(COLOR_WHITE, PAWN, x_start + half_piece_size * i,
					y_start + half_piece_size);
		}

		createPiece(COLOR_BLACK, ROOK, x_start + half_piece_size * 0, y_start
				+ ypos);

		createPiece(COLOR_BLACK, KNIGHT, x_start + half_piece_size * 1, y_start
				+ ypos);

		createPiece(COLOR_BLACK, BISHOP, x_start + half_piece_size * 2, y_start
				+ ypos);

		createPiece(COLOR_BLACK, KING, x_start + half_piece_size * 3, y_start
				+ ypos);

		createPiece(COLOR_BLACK, QUEEN, x_start + half_piece_size * 4, y_start
				+ ypos);

		createPiece(COLOR_BLACK, BISHOP, x_start + half_piece_size * 5, y_start
				+ ypos);

		createPiece(COLOR_BLACK, KNIGHT, x_start + half_piece_size * 6, y_start
				+ ypos);

		createPiece(COLOR_BLACK, ROOK, x_start + half_piece_size * 7, y_start
				+ ypos);

		for (int i = 0; i < 8; i++) {
			createPiece(COLOR_BLACK, PAWN, x_start + half_piece_size * i,
					y_start + ypos - half_piece_size);
		}

	}

	protected void paintComponent(Graphics g) {

		ArrayList<Piece> pp = pieces.getPieces();

		for (int n = 0; n < pp.size(); n++) {
			Piece p = pp.get(n);
			g.drawImage(p.getImage(), p.getX(), p.getY(), null);
		}

		int x = 0;
		int y = yoffset + board_size + 50;
		ArrayList<Piece> dp = pieces.getDeadpieces();
		for (int n = 0; n < dp.size(); n++) {
			Piece p = dp.get(n);
			x += 50;
			g.drawImage(p.getImage(), p.getX() + x, y, null);
		}
	}

	public void paint(Graphics g) {

		g.fillRect(xoffset, yoffset, board_size, board_size);

		for (int i = xoffset; i < board_size + xoffset; i += piece_size) {
			for (int j = xoffset; j < board_size + yoffset-50; j += piece_size) {
				g.clearRect(i, j, half_piece_size, half_piece_size);
			}
		}
		
		for (int i = xoffset + half_piece_size; i <board_size + xoffset; i += piece_size) {
			for (int j = xoffset + half_piece_size; j < board_size + xoffset; j += piece_size) {
				g.clearRect(i, j, half_piece_size, half_piece_size);
			}
		}

		g.drawRect(xoffset, yoffset, board_size, board_size);

		paintComponent(g);
	}

	Image getImageForPiece(int color, int type) throws IOException {

		String filename = "";

		filename += (color == COLOR_WHITE ? "w" : "b");
		switch (type) {
		case BISHOP:
			filename += "b";
			break;
		case KING:
			filename += "k";
			break;
		case KNIGHT:
			filename += "n";
			break;
		case PAWN:
			filename += "p";
			break;
		case QUEEN:
			filename += "q";
			break;
		case ROOK:
			filename += "r";
			break;
		}
		filename += ".png";

		// Chess Set Sizes (36 42 48 54 60)

		String sFilePath = "./ImageFolder/JinMotif/" + chess_size + "/" + filename;
		img = ImageIO.read(new File(sFilePath));

		return (img);
	}

	private void createPiece(int color, int type, int x, int y)
			throws IOException {
		Image img = this.getImageForPiece(color, type);

		if (img == null) {
			System.out.print("File Does Not Exist");
			System.exit(1);
		}
		Piece piece = new Piece(img, x, y);
		piece.setColor(color);
		piece.setType(type);
		piece.setSize(chess_size);

		pieces.getPieces().add(piece);

		Piece op = new Piece(img, x, y);
		op.setColor(color);
		op.setType(type);
		op.setSize(chess_size);
		orgPieces.getPieces().add(op);

	}

	public static void dummy() {

		listener.undoMoves();

	}

	public static void startGame() {

		listener.begin(orgPieces);
		gStart = false;
		enableSizeSelect();

	}

	public static void setSize(int size) throws IOException {

		chess_size = size;

		gStart = true;

		listener.reDraw();

		disableSizeSelect();

	}

	public enum PiecesType {
		BISHOP, ROOK, KING, KNIGHT, PAWN, QUUEN

	}

	public enum ColorType {
		WHITE, BLACK

	}

	public static void disableSizeSelect() {
		gMenu.disable();
	}

	public static void enableSizeSelect() {
		gMenu.enable();
	}

	public static void main(String[] args) throws IOException {

		JFrame frame = new JFrame("Try My Chess");

		frame.setSize(800, 850);

		JMenuBar menuBar = new JMenuBar();
		frame.setJMenuBar(menuBar);
		JMenu optionMenu = new JMenu("Options");
		JMenu optionSize = new JMenu("Sizes");
		menuBar.add(optionMenu);
		menuBar.add(optionSize);
		JMenuItem startGame = new JMenuItem("New Game");
		JMenuItem undoMove = new JMenuItem("Undo");
		JMenuItem piece_sizeA = new JMenuItem("Chess Size 36");
		JMenuItem piece_sizeB = new JMenuItem("Chess Size 43");
		JMenuItem piece_sizeC = new JMenuItem("Chess Size 48");
		JMenuItem piece_sizeD = new JMenuItem("Chess Size 54");
		JMenuItem piece_sizeE = new JMenuItem("Chess Size 60");

		JMenuItem quit = new JMenuItem("Quit");
		optionMenu.add(startGame);
		optionMenu.add(undoMove);
		optionSize.add(piece_sizeA);
		optionSize.add(piece_sizeB);
		optionSize.add(piece_sizeC);
		optionSize.add(piece_sizeD);
		optionSize.add(piece_sizeE);

		gMenu = optionSize;

		optionMenu.add(quit);

		startGame.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				// System.out.println("You have clicked on the start game");
				startGame();
			}
		});

		undoMove.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				// System.out.println("You have clicked on the Undo");
				dummy();
			}
		});

		quit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				// System.out.println("You have clicked on the quit");
				System.exit(0);
			}
		});

		piece_sizeA.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					setSize(36);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
		piece_sizeB.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					setSize(42);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
		piece_sizeC.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					setSize(48);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
		piece_sizeD.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					setSize(54);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
		piece_sizeE.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				try {
					setSize(60);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});

		frame.getContentPane().add(new ChessGui());
		frame.setLocationRelativeTo(null);
		frame.setBackground(Color.LIGHT_GRAY);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setVisible(true);

	}

}
