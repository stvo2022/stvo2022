package MyChess;
import java.awt.List;
import java.util.ArrayList;
import java.util.Iterator;


class Point {
	
	int x, y;
	Point ( int x,  int y) {
		
		this.x =x; this.y=y;
	}
	
}
class Trace {
	
	public ArrayList<Point> getPoints() {
		return points;
	}

	public void setPoints(ArrayList<Point> points) {
		this.points = points;
	}

	ArrayList<Point> points = new ArrayList<Point>();	
	
}

class Graph {
		
	public ArrayList<Trace> getTraces() {
		return traces;
	}

	public void setTraces(ArrayList<Trace> traces) {
		this.traces = traces;
	}

	ArrayList<Trace> traces = new ArrayList<Trace>();	
}

public class TestMain {

	public static void main(String[] args) {
		
		
	
		Graph graph = new Graph();
		Trace trace1 = new Trace();
		Trace trace2 = new Trace();
	
	
		
		Point p1 = new Point (0,1);
		Point p2 = new Point (0,2);
		trace1.points.add(p1);trace1.points.add(p2);
		graph.traces.add(trace1);
		
		Point p3 = new Point (0,3);
		Point p4 = new Point (0,4);
		Point p5 = new Point (0,5);
		trace2.points.add(p3);trace2.points.add(p4);trace2.points.add(p5);
		
	
		graph.traces.add(trace2);
		
		print(graph );
		
		System.out.println("piecesType: " + piecesType.BISHOP);
		
		
	}
	
	public static void print(Graph graph) {		
	
		ArrayList<Trace> t = graph.getTraces();
	
		for ( int n=0; n< t.size(); n++) {
			System.out.println("Points in Trace: " + n+1);
			Trace t1= t.get(n);
			ArrayList<Point> p = t1.getPoints();
			for ( int m=0; m< p.size(); m++) 
					System.out.println(p.get(m).x + " " +p.get(m).y);
			
		}
				
	}
	
	public enum piecesType {
		BISHOP, ROOK, KING, KNIGHT, PAWN, QUUEN
		
	}
	
	public enum ColorType {
		WHITE, BLACK
		
	}


}