% Определение цвета птиц:
color(dove, light).
color(parrot, light).
color(raven, dark).
color(rook, dark).
color(canary, light).
color(gull, light).
color(starling, dark).

% Определение "тезок": фамилия человека соответствует имени птицы:
namesake('Voronov', raven).
namesake('Golubev', dove).
namesake('Kanareykin', canary).
namesake('Grachev', rook).
namesake('Chaikin', gull).
namesake('Skvortsov', starling).
namesake('Popugaev', parrot).

% Реализация основного предиката решения: необходимо найти владельца скворца:
solve(Solution) :-
    People = [
        person('Voronov', VoronovBird, married),
        person('Golubev', GolubevBird, single),
        person('Kanareykin', KanareykinBird, single),
        person('Grachev', GrachevBird, married),
        person('Chaikin', ChaikinBird, married),
        person('Skvortsov', SkvortsovBird, married),
        person('Popugaev', PopugaevBird, married)
    ],

    Birds = [VoronovBird, GolubevBird, KanareykinBird, GrachevBird, ChaikinBird, SkvortsovBird, PopugaevBird], 
    
    permutation([raven, dove, canary, rook, gull, starling, parrot], Birds),

    % Ограничение: никто не держит птицу-"тезку":
    VoronovBird \= raven,
    GolubevBird \= dove,
    KanareykinBird \= canary,
    GrachevBird \= rook,
    ChaikinBird \= gull,
    SkvortsovBird \= starling,
    PopugaevBird \= parrot,

    % Ограничение: "У троих из них живут птицы, которые темнее, чем пернатые 'тезки' их хозяев":
    forall(member(person(Surname, Bird, _), People),
        (color(Bird, dark) -> 
            member(Surname, ['Golubev', 'Kanareykin', 'Chaikin', 'Popugaev']) 
        ; true)),

    % Ограничение: ""Тезка" птицы, которая живет у Воронова, женат":
    namesake(TezkaVoronova, VoronovBird), 
    member(person(TezkaVoronova, _, married), People),

    % Ограничение: "Хозяин грача женат на сестре жены Чайкина" -> Чайкин не держит грача:
    ChaikinBird \= rook,

    % Ограничение: "Хозяин грача женат на сестре жены Чайкина" -> хозяин грача женат:
    member(person(_, rook, married), People),

    % Ограничение: "Невеста хозяина ворона.." -> ворон принадлежит холостяку (не женатому):
    member(person(_, raven, single), People),
    
    % Ограничение: ""Тезка" птицы, которая живет у Грачева - хозяин канарейки":
    member(person('Grachev', GrachevBird, _), People),
    namesake(TezkaGracheva, GrachevBird),
    member(person(TezkaGracheva, canary, _), People),
   
    % Ограничение: "Птица, которая является "тезкой" владельца попугая, принадлежит "тезке" той птицы, которой владеет Воронов":
    member(person(PopugaiOwner, parrot, _), People),
    namesake(PopugaiOwner, Bird1),
    member(person(Bird1Owner, Bird1, _), People),
    namesake(PersonV, VoronovBird),
    Bird1Owner = PersonV,
    
    member(person(Solution, starling, _), People).