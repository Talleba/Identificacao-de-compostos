:- dynamic atomo/3.
:- dynamic ligacaosimples/3.
:- dynamic ligacaodupla/3.
:- dynamic ligacaotripla/3.

:- discontiguous atomo/3.
:- discontiguous ligacaosimples/3.
:- discontiguous ligacaodupla/3.
:- discontiguous ligacaotripla/3.

% =====================================
% REGRA DE LIGAÇÃO
% =====================================

ligacao_simples(M,A,B) :-
    ligacaosimples(M,A,B);
    ligacaosimples(M,B,A).

ligacao_dupla(M,A,B) :-
    ligacaodupla(M,A,B);
    ligacaodupla(M,B,A).

ligacao_tripla(M,A,B) :-
    ligacaotripla(M,A,B);
    ligacaotripla(M,B,A).

% =====================================
% GRUPOS FUNCIONAIS
% =====================================

% -------------------------------------
% ÁCIDO CARBOXÍLICO
% padrão: C dupla O, C simples O, O simples H
% -------------------------------------

acido_carboxilico(M) :-

    % existe um carbono
    atomo(M,C,carbono),

    % existe um oxigênio ligado duplamente ao carbono
    atomo(M,O1,oxigenio),
    ligacao_dupla(M,C,O1),

    % existe outro oxigênio ligado simplesmente ao carbono
    atomo(M,O2,oxigenio),
    ligacao_simples(M,C,O2),

    % existe um hidrogênio ligado a esse oxigênio
    atomo(M,H,hidrogenio),
    ligacao_simples(M,O2,H).

% -------------------------------------
% ALDEÍDO
% padrão: C dupla O, C simples H
% -------------------------------------

aldeido(M) :-

    % existe um carbono
    atomo(M,C,carbono),

    % existe um oxigênio ligado duplamente ao carbono
    atomo(M,O,oxigenio),
    ligacao_dupla(M,C,O),

    % existe um hidrogênio ligado ao carbono
    atomo(M,H,hidrogenio),
    ligacao_simples(M,C,H).

% -------------------------------------
% CETONA
% padrão: C dupla O, C simples C, C simples C
% -------------------------------------

cetona(M) :-

    % existe um carbono central
    atomo(M,C,carbono),

    % existe um oxigênio ligado duplamente ao carbono
    atomo(M,O,oxigenio),
    ligacao_dupla(M,C,O),

    % existe um carbono ligado simplesmente ao carbono central
    atomo(M,C1,carbono),
    ligacao_simples(M,C,C1),
    C1 \= C,

    % existe outro carbono ligado simplesmente ao carbono central
    atomo(M,C2,carbono),
    ligacao_simples(M,C,C2),
    C2 \= C,
    C2 \= C1,

    % garantir que NÃO é aldeído 
    \+ (
    ligacao_simples(M,C,H),
    atomo(M,H,hidrogenio)
    ),

    % garantir que NÃO é ácido carboxílico
    \+ (
        ligacao_simples(M,C,O3),
        ligacao_simples(M,O3,H2),
        atomo(M,O3,oxigenio),
        atomo(M,H2,hidrogenio)
    ).

% -------------------------------------
% AMINA PRIMÁRIA
% padrão: N ligado a 1 carbono e 2 hidrogenios
% -------------------------------------

amina_primaria(M) :-

    % existe um nitrogenio
    atomo(M,N,nitrogenio),

    % existe uma lista de carbonos ligados ao nitrogenio
    findall(C, (ligacao_simples(M,N,C), atomo(M,C,carbono)), ListaCarbonos),

    % existe exatamente 1 carbono ligado ao nitrogenio
    length(ListaCarbonos, 1),

    % existe uma lista de hidrogenios ligados ao nitrogenio
    findall(H, (ligacao_simples(M,N,H), atomo(M,H,hidrogenio)), ListaHidrogenios),

    % existe exatamente 2 hidrogenios ligados ao nitrogenio
    length(ListaHidrogenios, 2).

% -------------------------------------
% AMINA SECUNDÁRIA
% padrão: N ligado a 2 carbonos e 1 hidrogenio
% -------------------------------------

amina_secundaria(M) :-

    % existe um nitrogenio
    atomo(M,N,nitrogenio),

    % existe uma lista de carbonos ligados ao nitrogenio
    findall(C, (ligacao_simples(M,N,C), atomo(M,C,carbono)), ListaCarbonos),

    % existe exatamente 2 carbonos ligados ao nitrogenio
    length(ListaCarbonos, 2),

    % existe uma lista de hidrogenios ligados ao nitrogenio
    findall(H, (ligacao_simples(M,N,H), atomo(M,H,hidrogenio)), ListaHidrogenios),

    % existe exatamente 1 hidrogenio ligado ao nitrogenio
    length(ListaHidrogenios, 1).

% -------------------------------------
% AMINA TERCIÁRIA
% padrão: N ligado a 3 carbonos
% -------------------------------------

amina_terciaria(M) :-

    % existe um nitrogenio
    atomo(M,N,nitrogenio),

    % existe uma lista de carbonos ligados ao nitrogenio
    findall(C,
        (ligacao_simples(M,N,C), atomo(M,C,carbono)),
        ListaCarbonos),

    % existe exatamente 3 carbonos ligados ao nitrogenio
    length(ListaCarbonos, 3).

% -------------------------------------
% ÁLCOOL
% padrão: O simples C, O simples H
% -------------------------------------

alcool(M) :-

    % existe um oxigênio
    atomo(M,O,oxigenio),

    % existe um carbono ligado ao oxigênio
    atomo(M,C,carbono),
    ligacao_simples(M,O,C),

    % existe um hidrogênio ligado ao oxigênio
    atomo(M,H,hidrogenio),
    ligacao_simples(M,O,H),

    % garantir que NÃO é ácido carboxílico
    \+ (
        ligacao_simples(M,O,C),
        ligacao_dupla(M,C,O2),
        atomo(M,O2,oxigenio),
        O2 \= O
    ).

% -------------------------------------
% HALETO
% padrão: C simples halogenio
% -------------------------------------

halogenio(fluor).
halogenio(cloro).
halogenio(bromo).
halogenio(iodo).

haleto(M) :-

    % existe um carbono
    atomo(M,C,carbono),

    % existe um halogenio
    atomo(M,X,Tipo),

    % verifica se é halogenio
    halogenio(Tipo),

    % estão ligados
    ligacao_simples(M,C,X).

% =====================================
% PREDICADOS AUXILIARES
% =====================================

% amina/1 unifica se há qualquer tipo de amina
amina(M) :-
    amina_primaria(M);
    amina_secundaria(M);
    amina_terciaria(M).

% detect_func/2: mapeia um nome de função para o detector correspondente
detect_func(acido_carboxilico, M) :- acido_carboxilico(M).
detect_func(aldeido, M)           :- aldeido(M).
detect_func(cetona, M)            :- cetona(M).
detect_func(amina_primaria, M) :- amina_primaria(M).
detect_func(amina_secundaria, M) :- amina_secundaria(M).
detect_func(amina_terciaria, M) :- amina_terciaria(M).
detect_func(alcool, M)            :- alcool(M).
detect_func(haleto, M)            :- haleto(M).

% =====================================
% FUNÇÃO PRINCIPAL (com prioridade)
% prioridade: ácido carboxílico > aldeído > cetona > amina > álcool > haleto
% =====================================

funcao_principal(M, acido_carboxilico) :- acido_carboxilico(M), !.
funcao_principal(M, aldeido)           :- aldeido(M), !.
funcao_principal(M, cetona)            :- cetona(M), !.
funcao_principal(M, amina_primaria) :- amina_primaria(M), !.
funcao_principal(M, amina_secundaria) :- amina_secundaria(M), !.
funcao_principal(M, amina_terciaria) :- amina_terciaria(M), !.
funcao_principal(M, alcool)            :- alcool(M), !.
funcao_principal(M, haleto)            :- haleto(M), !.
% se nenhuma for encontrada, funcao_principal falha (retorna false)

% =====================================
% SUFIXOS
% =====================================

sufixo(acido_carboxilico, 'oico').
sufixo(aldeido, 'al').
sufixo(cetona, 'ona').
sufixo(amina_primaria, 'amina').
sufixo(amina_secundaria, 'amina').
sufixo(amina_terciaria, 'amina').
sufixo(alcool, 'ol').
sufixo(haleto, 'eto').

% =====================================
% NOMES SECUNDÁRIOS
% =====================================

nome_secundario(aldeido, oxo).
nome_secundario(cetona, oxo).

nome_secundario(amina_primaria, amino).
nome_secundario(amina_secundaria, amino).
nome_secundario(amina_terciaria, amino).

nome_secundario(alcool, hidroxi).

nome_secundario(haleto, M, Nome) :-
    atomo(M, X, Nome),
    halogenio(Nome),
    atomo(M, C, carbono),
    ligacao_simples(M, C, X).

% =====================================
% FUNÇÕES SECUNDÁRIAS
% Retorna lista ordenada e sem nomes repetidos das funções presentes,
% excluindo a função principal (se houver)
% =====================================

funcoes_secundarias(M, SecsFinal) :-

    % encontra todas as funções detectadas
    findall(F,(member(F, [acido_carboxilico, aldeido, cetona, amina_primaria, amina_secundaria, amina_terciaria, alcool, haleto]), detect_func(F, M)), Lista),
    sort(Lista, ListaUnica),     % remove os nomes repetidos e organiza a lista

    % retira a função principal da lista de secundárias (se existir)
    ( funcao_principal(M, Principal) -> subtract(ListaUnica, [Principal], ListaSemPrincipal); % remove Principal, se presente
        ListaSemPrincipal = ListaUnica ),

    % transforma em formato Nome(NomeSecundario)
    findall(Termo,
    (
        member(F, ListaSemPrincipal),
        (F = haleto -> nome_secundario(haleto, M, NomeSec);
        nome_secundario(F, NomeSec)),
        Termo =.. [F, NomeSec]
    ),
    SecsTemporaria),
    
    % remove duplicatas
    sort(SecsTemporaria, SecsFinal).


% =====================================
% IDENTIFICAR MOLÉCULA
% =====================================

identificar_molecula(M) :-
    ( funcao_principal(M, P) ->
        sufixo(P, Suf), write('Funcao principal: '), write(P), nl,
        write('Sufixo principal: '), write(Suf), nl;   
        write('Funcao principal: nenhuma encontrada'), nl ),

    funcoes_secundarias(M, Secs),
    write('Funcoes secundarias: '), write(Secs), nl.

ajuda :-
    write('===== SISTEMA DE IDENTIFICACAO MOLECULAR ====='), nl,
    write('Comandos disponiveis:'), nl,
    write('identificar_molecula(ID).                   -> Relatorio completo.'), nl,
    write('funcao_principal(ID, Principal).            -> Apenas funcao principal.'), nl,
    write('funcoes_secundarias(ID, Secundarias).       -> Apenas funcoes secundarias.'), nl,
    write('make.                                       -> Recarrega o ficheiro.'), nl,
    write('ATENCAO: os pontos finais (.) sao obrigatorios'), nl,
    write('=============================================='), nl.

% Molecula Simples 1 (Ácido Carboxílico)

atomo(s1,h1,hidrogenio).
atomo(s1,h2,hidrogenio).
atomo(s1,h3,hidrogenio).
atomo(s1,h4,hidrogenio).
atomo(s1,c1,carbono).
atomo(s1,c2,carbono).
atomo(s1,o1,oxigenio).
atomo(s1,o2,oxigenio).

ligacaosimples(s1,h1,c1).
ligacaosimples(s1,h2,c1).
ligacaosimples(s1,h3,c1).
ligacaosimples(s1,c1,c2).
ligacaosimples(s1,c2,o2).
ligacaosimples(s1,o2,h4).
ligacaodupla(s1,c2,o1).

ligacaotripla(xx,a,b).

%Molecula Simples 2 (Aldeido)

atomo(s2,h1,hidrogenio).
atomo(s2,h2,hidrogenio).
atomo(s2,h3,hidrogenio).
atomo(s2,h4,hidrogenio).
atomo(s2,c1,carbono).
atomo(s2,c2,carbono).
atomo(s2,o,oxigenio).

ligacaosimples(s2,h1,c1).
ligacaosimples(s2,h2,c1).
ligacaosimples(s2,h3,c1).
ligacaosimples(s2,c1,c2).
ligacaosimples(s2,c2,h4).
ligacaodupla(s2,c2,o).

ligacaotripla(xx,a,b).

%Molecula Simples 3 (Cetona)

atomo(s3,h1,hidrogenio).
atomo(s3,h2,hidrogenio).
atomo(s3,h3,hidrogenio).
atomo(s3,h4,hidrogenio).
atomo(s3,h5,hidrogenio).
atomo(s3,h6,hidrogenio).
atomo(s3,c1,carbono).
atomo(s3,c2,carbono).
atomo(s3,c3,carbono).
atomo(s3,o,oxigenio).

ligacaosimples(s3,h1,c1).
ligacaosimples(s3,h2,c1).
ligacaosimples(s3,h3,c1).
ligacaosimples(s3,c1,c2).
ligacaosimples(s3,c2,c3).
ligacaosimples(s3,c3,h4).
ligacaosimples(s3,c3,h5).
ligacaosimples(s3,c3,h6).
ligacaodupla(s3,c2,o).

ligacaotripla(xx,a,b).

%Molecula Simples 4  (Amina Primária)

atomo(s4,h1,hidrogenio).
atomo(s4,h2,hidrogenio).
atomo(s4,h3,hidrogenio).
atomo(s4,h4,hidrogenio).
atomo(s4,h5,hidrogenio).
atomo(s4,c,carbono).
atomo(s4,n,nitrogenio).

ligacaosimples(s4,h1,c).
ligacaosimples(s4,h2,c).
ligacaosimples(s4,h3,c).
ligacaosimples(s4,c,n).
ligacaosimples(s4,n,h4).
ligacaosimples(s4,n,h5).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 5 (Amina Secundária)

atomo(s5,h1,hidrogenio).
atomo(s5,h2,hidrogenio).
atomo(s5,h3,hidrogenio).
atomo(s5,h4,hidrogenio).
atomo(s5,h5,hidrogenio).
atomo(s5,h6,hidrogenio).
atomo(s5,h7,hidrogenio).
atomo(s5,c1,carbono).
atomo(s5,c2,carbono).
atomo(s5,n,nitrogenio).

ligacaosimples(s5,h1,c1).
ligacaosimples(s5,h2,c1).
ligacaosimples(s5,h3,c1).
ligacaosimples(s5,c1,n).
ligacaosimples(s5,n,h4).
ligacaosimples(s5,n,c2).
ligacaosimples(s5,c2,h5).
ligacaosimples(s5,c2,h6).
ligacaosimples(s5,c2,h7).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 6 (Amina Terciária)

atomo(s6,h1,hidrogenio).
atomo(s6,h2,hidrogenio).
atomo(s6,h3,hidrogenio).
atomo(s6,h4,hidrogenio).
atomo(s6,h5,hidrogenio).
atomo(s6,h6,hidrogenio).
atomo(s6,h7,hidrogenio).
atomo(s6,h8,hidrogenio).
atomo(s6,h9,hidrogenio).
atomo(s6,c1,carbono).
atomo(s6,c2,carbono).
atomo(s6,c3,carbono).
atomo(s6,n,nitrogenio).

ligacaosimples(s6,h1,c1).
ligacaosimples(s6,h2,c1).
ligacaosimples(s6,h3,c1).
ligacaosimples(s6,c1,n).
ligacaosimples(s6,n,c2).
ligacaosimples(s6,c2,h4).
ligacaosimples(s6,c2,h5).
ligacaosimples(s6,c2,h6).
ligacaosimples(s6,n,c3).
ligacaosimples(s6,c3,h7).
ligacaosimples(s6,c3,h8).
ligacaosimples(s6,c3,h9).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 7 (Álcool)

atomo(s7,h1,hidrogenio).
atomo(s7,h2,hidrogenio).
atomo(s7,h3,hidrogenio).
atomo(s7,h4,hidrogenio).
atomo(s7,h5,hidrogenio).
atomo(s7,h6,hidrogenio).
atomo(s7,c1,carbono).
atomo(s7,c2,carbono).
atomo(s7,o,oxigenio).

ligacaosimples(s7,h1,c1).
ligacaosimples(s7,h2,c1).
ligacaosimples(s7,h3,c1).
ligacaosimples(s7,c1,c2).
ligacaosimples(s7,c2,h4).
ligacaosimples(s7,c2,h5).
ligacaosimples(s7,c2,o).
ligacaosimples(s7,o,h6).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 8 (Haleto Cloro)

atomo(s8,h1,hidrogenio).
atomo(s8,h2,hidrogenio).
atomo(s8,h3,hidrogenio).
atomo(s8,c,carbono).
atomo(s8,cl,cloro).

ligacaosimples(s8,h1,c).
ligacaosimples(s8,h2,c).
ligacaosimples(s8,h3,c).
ligacaosimples(s8,c,cl).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 9 (Haleto Fluor)

atomo(s9,h1,hidrogenio).
atomo(s9,h2,hidrogenio).
atomo(s9,h3,hidrogenio).
atomo(s9,c,carbono).
atomo(s9,f,fluor).

ligacaosimples(s9,h1,c).
ligacaosimples(s9,h2,c).
ligacaosimples(s9,h3,c).
ligacaosimples(s9,c,f).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 10 (Haleto Bromo)

atomo(s10,h1,hidrogenio).
atomo(s10,h2,hidrogenio).
atomo(s10,h3,hidrogenio).
atomo(s10,c,carbono).
atomo(s10,br,bromo).

ligacaosimples(s10,h1,c).
ligacaosimples(s10,h2,c).
ligacaosimples(s10,h3,c).
ligacaosimples(s10,c,br).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 11 (Haleto Iodo)

atomo(s11,h1,hidrogenio).
atomo(s11,h2,hidrogenio).
atomo(s11,h3,hidrogenio).
atomo(s11,c,carbono).
atomo(s11,i,iodo).

ligacaosimples(s11,h1,c).
ligacaosimples(s11,h2,c).
ligacaosimples(s11,h3,c).
ligacaosimples(s11,c,i).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

%Molecula Simples 12 (Nada)

atomo(s12,h1,hidrogenio).
atomo(s12,h2,hidrogenio).
atomo(s12,h3,hidrogenio).
atomo(s12,h4,hidrogenio).
atomo(s12,h5,hidrogenio).
atomo(s12,h6,hidrogenio).
atomo(s12,c1,carbono).
atomo(s12,c2,carbono).

ligacaosimples(s12,h1,c1).
ligacaosimples(s12,h2,c1).
ligacaosimples(s12,h3,c1).
ligacaosimples(s12,c1,c2).
ligacaosimples(s12,c2,h4).
ligacaosimples(s12,c2,h5).
ligacaosimples(s12,c2,h6).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).

% Molecula Simples 13 (Amina + Alcool + Haleto(Cloro) + Haleto(Fluor))

% Hidrogenios
atomo(s13,h1,hidrogenio).
atomo(s13,h2,hidrogenio).
atomo(s13,h3,hidrogenio).
atomo(s13,h4,hidrogenio).
atomo(s13,h5,hidrogenio).
atomo(s13,h6,hidrogenio).


% Carbonos
atomo(s13,c1,carbono).
atomo(s13,c2,carbono).
atomo(s13,c3,carbono).
atomo(s13,c4,carbono).

% Nitrogenio (amina)
atomo(s13,n,nitrogenio).

% Oxigenio (alcool)
atomo(s13,o,oxigenio).

% Haleto (cloro)
atomo(s13,cl,cloro).

% Haleto (fluor)
atomo(s13,f,fluor).

% Ligações da cadeia principal
ligacaosimples(s13,c1,c2).
ligacaosimples(s13,c2,c3).
ligacaosimples(s13,c3,c4).

% Amina primaria (NH2)
ligacaosimples(s13,c1,n).
ligacaosimples(s13,n,h1).
ligacaosimples(s13,n,h2).

% Hidrogenios do c1
ligacaosimples(s13,c1,h3).

% Alcool (OH)
ligacaosimples(s13,c2,o).
ligacaosimples(s13,o,h4).

% Hidrogenios do c2
ligacaosimples(s13,c2,h5).

% Haleto (F)
ligacaosimples(s13,c4,f).

% Haleto (Cl)
ligacaosimples(s13,c3,cl).

% Hidrogenios do c3
ligacaosimples(s13,c3,h6).

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).