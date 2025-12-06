% Реалиация предиката перемещения черного шара вправо на одну позицию (в соседнюю пустую лунку):
move(State, NewState) :-
    append(Left, [b,'_'|Right], State),
    append(Left, ['_',b|Right], NewState).

% Реалиация предиката перепрыгивания черного шара через один шар вправо (через b или w):
move(State, NewState) :-
    append(Left, [b,X,'_'|Right], State),
    member(X,[b,w]),
    append(Left, ['_',X,b|Right], NewState).

% Реалиация предиката перемещения белого шара влево на одну позицию (в соседнюю пустую лунку):
move(State, NewState) :-
    append(Left, ['_',w|Right], State),
    append(Left, [w,'_'|Right], NewState).

% Реалиация предиката перепрыгивание белого шара через один шар влево (через b или w):
move(State, NewState) :-
    append(Left, ['_',X,w|Right], State),
    member(X,[b,w]),
    append(Left, [w,X,'_'|Right], NewState).


% DFS (поиск в глубину):
dfs(Goal, Goal, Path, Path).
dfs(Current, Goal, Visited, Path) :-
    move(Current, Next),
    \+ member(Next, Visited),
    dfs(Next, Goal, [Next|Visited], Path).

solve_dfs(Start, Goal, Path) :-
    dfs(Start, Goal, [Start], RevPath),
    reverse(RevPath, Path).


% BFS (поиск в ширину):
bfs_queue([Goal-PathSoFar|_], Goal, PathSoFar).
bfs_queue([Current-PathSoFar|RestQueue], Goal, Path) :-
    findall(Next-[Next|PathSoFar],
            ( move(Current, Next),
              \+ member(Next, PathSoFar)
            ),
            NewPaths),
    append(RestQueue, NewPaths, Queue),
    bfs_queue(Queue, Goal, Path).

solve_bfs(Start, Goal, Path) :-
    bfs_queue([Start-[]], Goal, RevPath),
    reverse(RevPath, Path).


% IDDFS (гибрид DFS и BFS):
iddfs(Goal, Goal, Path, _, Path).
iddfs(Current, Goal, Visited, Depth, Path) :-
    Depth > 0,
    move(Current, Next),
    \+ member(Next, Visited),
    NewDepth is Depth - 1,
    iddfs(Next, Goal, [Next|Visited], NewDepth, Path).

solve_iddfs(Start, Goal, Path) :-
    between(1,100,Depth),
    iddfs(Start, Goal, [Start], Depth, RevPath),
    reverse(RevPath, Path),
    !.


% Реализация предикатов вывода состояния 
print_state([]) :- nl.
print_state([H|T]) :- write(H), write(' '), print_state(T).

print_path([]).
print_path([H|T]) :- print_state(H), print_path(T).


% Реализация основного предиката решения
solve :-
    Start = [b,b,b,b,'_',w,w,w],
    Goal  = [w,w,w,'_',b,b,b,b],

    write('DFS solution:'), nl,
    solve_dfs(Start, Goal, PathDFS),
    print_path(PathDFS),
    length(PathDFS,L1),
    Steps1 is L1-1,
    write('Steps: '), write(Steps1), nl,

    writeln(''),

    write('BFS solution:'), nl,
    solve_bfs(Start, Goal, PathBFS),
    print_path(PathBFS),
    length(PathBFS,L2),
    Steps2 is L2,
    write('Steps: '), write(Steps2), nl,

    writeln(''),

    write('IDDFS solution:'), nl,
    solve_iddfs(Start, Goal, PathIDDFS),
    print_path(PathIDDFS),
    length(PathIDDFS,L3),
    Steps3 is L3-1,
    write('Steps: '), write(Steps3), nl.