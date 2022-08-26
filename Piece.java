package MyChess;
import java.awt.Image;

public class Piece {
	 
    public Image getImg() {
		return img;
	}

	public void setImg(Image img) {
		this.img = img;
	}

	public int getW() {
		return w;
	}

	public void setW(int w) {
		this.w = w;
	}

	public int getH() {
		return h;
	}

	public void setH(int h) {
		this.h = h;
	}

	private Image img;
    private int x;
    private int y;
    private int w=50;
    private int h=50;
    
    private int color;
    public int getColor() {
		return color;
	}

	public void setColor(int color) {
		this.color = color;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getSize() {
		return size;
	}

	public void setSize(int size) {
		this.size = size;
	}

	private int type;
    private int size;
    
    Piece (Image img, int x, int y) {
    	this.img = img;
    	this.x = x;
    	this.y = y;
    	
    }
    
    public Piece(Piece piece) {
    	img = piece.getImage();
		x = piece.getX();
		y = piece.getY();
		w = piece.getWidth();
		w = piece.getHeight();
		
	}

	int getX() {
    	return x;
    	
    }
    void setX (int x){
    	this.x = x;
    }
    void setY (int y){
    	this.y = y;
    }
    int getY() {
    	return y;
    	
    }
    int getWidth() {
    	return w;
    	
    }
    int getHeight() {
    	return h;
    	
    }
    
    Image getImage() {
    	return img;
    }
 }