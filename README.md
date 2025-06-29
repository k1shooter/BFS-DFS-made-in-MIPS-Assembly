# BFS-DFS-made-in-MIPS-Assembly

## Installation

You have to download QtSpim to run .s file.
[QtSpim](http://spimsimulator.sourceforge.net/)

## Assumption

- The graph contains vertices numbered from 1 to N

- There cannot be more than one edge between any two vertices

- Each edge can be traversed in both directions.

- If multiple vertices are available to visit, prioritize the vertex with the smaller
number.

- Graph traversal ends when no more vertices can be visited

- Same weights on edges

## input format

- The number of vertices N (1 ≤ N ≤ 300) is given in the first line.

- The number of edges M (1 ≤ M ≤ 10,000) is given in the second line.

- The start vertex number V (1 ≤ V ≤ N) is given in the third line.

- The two vertices of the k-th edge (1 ≤ k ≤ M) are given in the (2k + 2)-th and
(2k + 3)-th lines, respectively.

## output format

- The first line displays the graph traversal results of the DFS.

- The second line displays the graph traversal results of the BFS.

## Running

- input

```
6
10
2
4
2
3
4
4
6
2
6
3
5
4
5
1
4
1
6
2
5
1
2
```

- output

```
2 1 4 3 5 6
2 1 4 5 6 3
```

## evaluation

```
input11: Time out occurs!
input13: Time out occurs!
input16: Time out occurs!
input17: Time out occurs!
input2: DFS correct
input2: BFS correct
input3: DFS correct
input3: BFS correct
input4: DFS correct
input4: BFS correct
input5: DFS correct
input5: BFS correct
input6: DFS correct
input6: BFS correct
input7: DFS correct
input7: BFS correct
input8: DFS correct
input8: BFS correct
input9: DFS correct
input9: BFS correct
input10: DFS correct
input10: BFS correct
input11: DFS correct
input12: DFS correct
input12: BFS correct
input14: DFS correct
input14: BFS correct
input15: DFS correct
input15: BFS correct
input18: MIPS error occurs!
input19: MIPS error occurs!
input20: MIPS error occurs!
```
