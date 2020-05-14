class Automata {
    constructor(loneliness, overpopulation, reproduction, rows, cols) {
        // assign attributes
        this.lone = loneliness;
        this.overpop = overpopulation;
        this.repro = reproduction;
        this.rows = rows;
        this.cols = cols;

        // create state matrix
        this.state = new Array(cols);
        for (let i = 0; i < cols; i++) {
            this.state[i] = new Array(rows);
        }
    }

    initialize() {
        for (let x = 0; x < this.cols; x++) {
            for (let y = 0; y < this.rows; y++) {
                this.state[x][y] = new Automaton(0);
            }
        } 
    }

    num_of_neighbors(x, y) {
        // get cell's amount of neighbors
        let neighbors = 0;
        for (let i = -1; i <= 1; i++) {
            for (let j = -1; j <= 1; j++) {
                neighbors += this.state[x+i][y+j].value;
            }
        }
        // remove extra unit if state[x][y] is active
        return neighbors - this.state[x][y].value;
    }

    apply_rules(x, y, neighbors, aux) {
        // apply defined rules to (x, y)
        if (this.state[x][y].value == 1 && neighbors < this.lone) {
            aux[x][y].value = 0;
        } else if (this.state[x][y].value == 1 && neighbors > this.overpop) {
            aux[x][y].value = 0;
        } else if (this.state[x][y].value == 0 && neighbors == this.repro) {
            aux[x][y].value = 1;
        } else {
            aux[x][y].value = this.state[x][y].value;
        }
    }

    evolve() {
        // evolve automata
        
        // create aux matrix
        let aux = new Array(this.cols);
        for (let i = 0; i < this.cols; i++) {
            aux[i] = new Array(this.rows);
            for (let j = 0; j < this.rows; j++) {
                aux[i][j] = new Automaton(0);
            }
        }

        // compute new state
        for (let x = 1; x < this.cols - 1; x++) {
            for (let y = 1; y < this.rows - 1; y++) {
                let neighbors = this.num_of_neighbors(x, y);
                this.apply_rules(x, y, neighbors, aux);
            }
        } 
        // swap states
        let temp = this.state;
        this.state = aux;
        aux = temp;
    }
}
