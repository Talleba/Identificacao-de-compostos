README: 

# Identificador de Grupos Funcionais
Este programa em Prolog foi desenvolvido para a disciplina de Lógica Computacional 2. Ele identifica automaticamente a função química principal, o sufixo de nomenclatura e todas as funções secundárias de uma molécula orgânica representada como um grafo.

**Grupo:**  
Pedro Alonso Fernandes de Aguiar,  
Talles Vieira Ferreira Bazani Gonçalves.


## 1. Instalação e Configuração do Ambiente

Para executar este módulo, você precisará do **SWI-Prolog**.

**Download:**  
Acesse swi-prolog.org e baixe a versão estável para o seu sistema operacional (Windows, Mac ou Linux).

**Instalação:**  
Siga as instruções padrão do instalador. No Windows, certifique-se de marcar a opção para adicionar o executável ao **PATH** do sistema para facilitar o uso.

## 2. Como Executar o Código

Existem duas formas principais de carregar seu trabalho no **SWI-Prolog**:

**Via Menu:** 
No menu superior, vá em File -> Consult e selecione o arquivo ```Identificador.pl```.

**Via Linha de Comando:**
Você pode digitar o caminho do arquivo diretamente no terminal do Prolog. Para isso, você deve copiar o caminho de onde o arquivo está salvo, colocá-lo entre aspas simples e colchetes, e inverter as barras (usar ```(/)``` em vez de ```(\)```).

**Atenção:**  
Toda vez eu o arquivo for alterado, deve-se salvar o mesmo e carregar novamente no console, seja com alguma dessas formas acima ou com o ```make.```

**Exemplo Genérico:**  
Se o seu arquivo está em ```C:\Projetos\Prolog\Identificador.pl```, você deve digitar no terminal:
```
?- ['C:/Projetos/Prolog/Identificador.pl'].
```

**Dica:**   
Se você fizer qualquer alteração no código (como adicionar uma nova molécula), não precisa fechar o programa ou refazer os passos. Basta digitar ```make.``` e o Prolog recarregará o arquivo automaticamente, excluindo os antigos e substituindo pelos novos, afim de evitar erros no banco de dados.

**Atenção:**  
Todas as vezes que for utilizar algum comando no console, coloque ponto final ```(.)```.

## 3. Como Consultar uma Molécula e Outros Comandos Disponíveis

### A) Identificação Completa
Após carregar o arquivo, utilize o predicado ```identificar_molecula(ID).```, onde ID é o nome dado à molécula.

Exemplo de consulta, no **SWI-Prolog**, da molécula com ID = s13:

**(ENTRADA)**

```
?- identificar_molecula(s13). 
```

**(SAÍDA)**

```
Funcao principal: amina_primaria
Sufixo principal: amina
Funcoes secundarias: [alcool(hidroxi),haleto(cloro),haleto(fluor)]
true.
```

**O que a saída significa:**

Função principal: O grupo de maior prioridade química.

Sufixo principal: A terminação usada para o nome da molécula.

Funções secundárias: Uma lista de todos os outros grupos encontrados, exibidos com seus nomes de substituintes (ex: hidroxi, amino).

### B) Consultas Específicas
Se quiser investigar apenas uma parte da molécula, você pode usar os predicados internos:

**Apenas para a Função Principal:**  
Utilize o predicado ```funcao_principal(ID, Principal).```, onde ID é o nome dado à molécula e Principal é o nome que será impresso para representar a função principal.

Exemplo de consulta, no **SWI-Prolog**, da molécula com ID = s13:

**(ENTRADA)**

```
?- funcao_principal(s13, Principal).
```

**(SAÍDA)**

```
Principal = amina_primaria.
```

**O que a saída significa:**

Principal: O grupo de maior prioridade química.

**Apenas para as Funções Secundárias:**   
Utilize o predicado ```funcoes_secundarias(ID, Secundarias).```, onde ID é o nome dado à molécula e Secundarias é o nome que será impresso para representar as funções secundárias.

Exemplo de consulta, no **SWI-Prolog**, da moléculas com ID = s13:

**(ENTRADA)**

```
?- funcoes_secundarias(s13, Secundarias).
```

**(SAÍDA)**

```
Secundarias = [alcool(hidroxi), haleto(cloro), haleto(fluor)].
```

**O que a saída significa:**

Secundarias: Uma lista de todos os outros grupos encontrados, exibidos com seus nomes de substituintes.

### C) Comando de Ajuda

Caso não recorde quais são os comandos disponíveis para uso no console, utilize ```ajuda.```.

Exemplo:

**(ENTRADA)**

```
?- ajuda.
```

**(SAÍDA)**

```
===== SISTEMA DE IDENTIFICACAO MOLECULAR =====
Comandos disponiveis:
identificar_molecula(ID).                   -> Relatorio completo.
funcao_principal(ID, Principal).            -> Apenas funcao principal.
funcoes_secundarias(ID, Secundarias).       -> Apenas funcoes secundarias.
molecula_existe(ID).                        -> Verifica se a molecula existe.
molecula_valida(ID).                        -> Verifica se a molecula tem valencia valida.
make.                                       -> Recarrega o ficheiro.
ajuda.                                      -> Exibe esta mensagem de ajuda.
ATENCAO: os pontos finais (.) sao obrigatorios
==============================================
true.
```

## 4. Como Adicionar Novas Moléculas

Para inserir uma nova molécula, você deve definir seus átomos e as ligações entre eles no final do ```Identificador.pl```. Siga atentamente as regras de sintaxe abaixo para evitar erros de compilação. Além disso, certifique-se de que os átomos respeitam suas valências máximas, caso contrário a molécula será considerada estruturalmente inválida pelo sistema.

### A) Regras Importantes de Escrita

**Apenas Letras Minúsculas:**  
Nunca use letras maiúsculas nos nomes de moléculas, átomos ou elementos (o Prolog entende maiúsculas como variáveis e o código não funcionará).

**Sem Caracteres Especiais:**  
Não utilize símbolos, "ç" ou acentos (use oxigenio em vez de oxigênio, hidrogenio em vez de hidrogênio).

**Nomes Únicos para Átomos:**  
Cada átomo dentro de uma molécula precisa de um identificador exclusivo (ex: c1, c2, o1, o2), mesmo quando são do mesmo tipo, por exemplo c1 é carbono e c2 também. Não pode ter apenas um "c" para representar dois carbonos diferentes, e o mesmo serve para os outros átomos, como oxigênio, hidrogênio e os demais.

### B) Definindo Átomos

**Para criar um átomo:**  
Use o predicado: atomo(NomeDaMolecula, NomeDoAtomo, Elemento). 

**Diferenciando Átomos:**  
Se sua molécula tem dois Oxigênios, você deve chamá-los, por exemplo, de o1 e o2.

**Elementos permitidos:**   
carbono, hidrogenio, oxigenio, nitrogenio, cloro, fluor, bromo, iodo.

### C) Definindo Ligações

Use os predicados de acordo com o tipo de ligação química:

**Para fazer uma ligação simples entre dois átomos:**  
ligacaosimples(NomeDaMolecula, Atomo1, Atomo2). 

**Para fazer uma ligação dupla entre dois átomos:**  
ligacaodupla(NomeDaMolecula, Atomo1, Atomo2). 

**Para fazer uma ligação tripla entre dois átomos:**  
ligacaotripla(NomeDaMolecula, Atomo1, Atomo2). 

### D) Exemplo Completo

Observe como cada átomo de oxigênio e carbono possui um número para ser diferenciado:

```
% Definindo os átomos da molécula 'm1' (Ácido Acético)
atomo(m1, c1, carbono).     
atomo(m1, c2, carbono).
atomo(m1, o1, oxigenio).    % Primeiro oxigênio (da dupla)
atomo(m1, o2, oxigenio).    % Segundo oxigênio (da hidroxila)
atomo(m1, h1, hidrogenio).

% Definindo as ligações
ligacaosimples(m1, c1, c2).
ligacaodupla(m1, c2, o1).   % Ligação dupla C=O
ligacaosimples(m1, c2, o2). % Ligação simples C-O
ligacaosimples(m1, o2, h1). % Ligação simples O-H
```

**Atenção:**   
Se você esquecer um ponto final ```(.)``` ao final de qualquer linha acima, o Prolog apresentará um erro de sintaxe ao carregar o arquivo.

**Obs.:**  
Tudo que vem logo na frente das porcentagens ```(%)``` são apenas comentários, eles não são necessários para o código funcionar, servem apenas para demonstrar o que está sendo feito em cada linha. Além de que, a molécula m1 não está no arquivo ```Identificador.pl```, se quiser, pode utilizá-la como exemplo prático e implementá-la.

## 5. Hierarquia de Prioridade

O programa determina a função principal seguindo a ordem decrescente de prioridade exigida:

- **Ácido Carboxílico** (Sufixo: oico) 

- **Aldeído** (Sufixo: al) 

- **Cetona** (Sufixo: ona) 

- **Amina** (Sufixo: amina) 

- **Álcool** (Sufixo: ol) 

- **Haleto** (Sufixo: eto)

## 6. Nomenclatura de Grupos Secundários

Quando uma molécula possui mais de um grupo funcional, o programa identifica apenas o de maior prioridade como a Função Principal. Todos os outros grupos são listados como Funções Secundárias, e seus nomes são convertidos automaticamente para a forma de substituinte:

- **Ácido Carboxílico:** Nunca vai ser função secundária pois possui maior prioridade

- **Aldeído:** oxo

- **Cetona:** oxo

- **Amina:** amino

- **Álcool:** hidroxi

- **Haleto:** (o nome do átomo: cloro, bromo, iodo ou fluor.)

Exemplo:

Se você consultar uma molécula que tem uma Amina e um Álcool, a Amina será a principal (por prioridade) e o Álcool aparecerá na lista de secundárias como hidroxi.

Exemplo de consulta, no **SWI-Prolog**, da molécula com ID = s13:

**(ENTRADA)**

```
?- identificar_molecula(s13). 
```

**(SAÍDA)**

```
Funcao principal: amina_primaria
Sufixo principal: amina
Funcoes secundarias: [alcool(hidroxi),haleto(cloro),haleto(fluor)]
true.
```

## 7. Validação Estrutural e Regras de Valência

O sistema possui um mecanismo interno de validação química para garantir que as moléculas criadas respeitem as regras de valência dos átomos.

### A) Verificação de Existência

O sistema realiza verificação automática da existência da molécula antes de executar qualquer análise.

Caso uma molécula não exista na base de dados, o sistema exibirá uma mensagem informando que a molécula não foi encontrada.

```
Erro: molecula ID nao existe.
```

Exemplo:

**(ENTRADA)**

```
?- identificar_molecula(s999).
```

**(SAÍDA)**

```
Erro: molecula s999 nao existe.
false.
```

Isso se aplica aos seguintes predicados:

- funcao_principal/2

- funcoes_secundarias/2

- identificar_molecula/1

- molecula_valida/1

- molecula_existe/1

Observação: o predicado ```identificar_molecula/1``` possui sua própria mensagem específica, mas também informa quando a molécula não existe e ```molecula_existe/1``` apenas retorna ```false.```.

### B) Regra de Valência Máxima

Cada átomo possui um limite máximo de ligações permitido:

- **carbono** → 4 ligações

- **oxigenio** → 2 ligações

- **nitrogenio** → 3 ligações

- **hidrogenio** → 1 ligação

- **halogenios (cloro, bromo, fluor, iodo)** → 1 ligação

O sistema calcula automaticamente a soma das ligações simples, duplas e triplas de cada átomo.

### C) Verificação Manual da Validade

Para verificar se uma molécula respeita as regras estruturais, utilize:


```
?- molecula_valida(ID).
```

Caso esteja correta, será exibido:

```
true.
```

Caso algum átomo ultrapasse sua valência máxima, será exibido:

```
Erro de valencia na molecula ID: atomo ATOMO (TIPO) tem X ligacoes.
Maximo permitido = MAX
```
Sendo:

- **ID** → Identificador da molécula

- **ATOMO** → Identificador único do átomo dentro da molécula

- **TIPO** → Tipo químico do átomo

- **X** → Número total de ligações que o átomo possui atualmente

- **MAX** → Número máximo de ligações permitidas para o tipo de átomo (valência máxima)


**Exemplo com uma molécula inválida:**

ESTRUTURA DA MOLÉCULA:

```
% Molecula Inválida 1 (Carbono com 5 ligações)

atomo(inv1,c1,carbono).
atomo(inv1,h1,hidrogenio).
atomo(inv1,h2,hidrogenio).
atomo(inv1,h3,hidrogenio).
atomo(inv1,h4,hidrogenio).
atomo(inv1,h5,hidrogenio).

ligacaosimples(inv1,c1,h1).
ligacaosimples(inv1,c1,h2).
ligacaosimples(inv1,c1,h3).
ligacaosimples(inv1,c1,h4).
ligacaosimples(inv1,c1,h5).  % <- ligação extra inválida

ligacaodupla(xx,a,b).
ligacaotripla(xx,a,b).
```

VERIFICANDO MOLÉCULA inv1:

**(ENTRADA)**

```
?- molecula_valida(inv1).
```

**(SAÍDA)**

```
Erro de valencia na molecula inv1: atomo c1 (carbono) tem 5 ligacoes.
Maximo permitido = 4
false.
```

## 8. Suporte e Contato

Caso encontre algum erro na identificação das moléculas ou tenha dificuldades na execução do módulo, entre em contato com os desenvolvedores:

Pedro Alonso Fernandes de Aguiar: [pedroalonso2005@hotmail.com]

Talles Vieira Ferreira Bazani Gonçalves: [tallesbazani@live.com]
