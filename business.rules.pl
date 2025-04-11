%=====================================================================================
% Caso de uso: Crear Grupo

% A group of four person.
group(trip, [john, mary, paul, jane]).


% add new group
add_new_group(NewGroup, CurrentGroups, CurrentGroups) :-
    member(NewGroup, CurrentGroups),
    !.
add_new_group(NewGroup, CurrentGroups, [NewGroup|CurrentGroups]).

% example
% add_new_group(trip, [], X).

%=====================================================================================
% Caso de uso: Agregar personas al grupo

% add user to group.
add_user_to_group(Person, CurrentMembers, CurrentMembers) :-
    member(Person, CurrentMembers),
    !.
add_user_to_group(Person, CurrentMembers, [Person|CurrentMembers]).

% example
% add_user_to_group(juan, [], X).

%=====================================================================================
% caso de uso: Registrar gastos

% expenses of a group
person_owes(mary, john, 50). % mary owes 50 to john
person_owes(paul, john, 50).
person_owes(mary, paul, 20).
person_owes(mary, paul, -20). % mary paid 20 to paul

%=====================================================================================
% Caso de uso: Ver resumen del grupo

% checks if someone owes money to another person.
debt(Person1, Person2) :-
    person_owes(Person1, Person2, _).

% checks total balance by person.
check_balance(Person, Total) :-
    Total >= 0 -> format( '~w be in debt  ~w', [Person, Total]);
    Total < 0 -> format( '~w get back ~d', [Person, Total* -1]).

% Calculate total balance by person.
calculate_total_balance(Person) :-
    findall(Amount, person_owes(Person, _, Amount), NegativeBalanceList),
    findall(Amount, person_owes(_, Person, Amount), PositiveBalanceList),
    sum_list(NegativeBalanceList, TotalNegative),
    sum_list(PositiveBalanceList, TotalPositive),
    SubTotal is TotalNegative + -1 * TotalPositive,
    check_balance(Person, SubTotal).

% example.
% calculate_total_balance(john).

%=====================================================================================
% Caso de uso; sugerir pagos

total_balance(john, -100).
total_balance(mary, 50).
total_balance(paul, 50).
total_balance(alex, -50).


suggest_payment(Person):-
    total_balance(Person, Total),
    Total < 0 -> find_positive(-1 * Total), format('to ~w.~n', [Person]).

find_positive(Total):-
    findall(Person-Amount, (total_balance(Person, Amount), Amount >= 0), Debts),
    show_payments(Total, Debts).

find_negative(Total):-
        findall(Person-Amount, (total_balance(Person, Amount), Amount < 0), Debts),
        show_payments(Total, Debts).

show_payments(Total, [Person-Amount| T]):-
    Total > Amount ->  format('~w should pay ~d.~n', [Person, Amount]), show_payments(Total - Amount, T), true;
    Total < Amount -> format('~w should pay ~d.~n', [Person, Total]);
    Total =:= Amount -> format('~w should pay ~d.~n', [Person, Total]).

% example
% suggest_payment(john).