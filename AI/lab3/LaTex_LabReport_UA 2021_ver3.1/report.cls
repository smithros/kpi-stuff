\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{report}[2020/03/17]
\typeout{AUTHOR: KPI}

\DeclareOption{12pt}{ \PassOptionsToClass{12pt}{article} }
\DeclareOption{KPI}{ \PassOptionsToClass{KPI}{article} }
\DeclareOption{letterpaper}{ \PassOptionsToClass{letterpaper}{article} }


% Declare font options
\DeclareOption{Helvetica}{\renewcommand{\rmdefault}{phv}}
\DeclareOption{AvantGarde}{\renewcommand{\rmdefault}{pag}}
\ProcessOptions
\LoadClass[letterpaper,oneside,onecolumn]{article}

%\usepackage[section]{placeins}
%---------------------------------------
\usepackage{placeins}

\let\Oldsection\section
\renewcommand{\section}{\FloatBarrier\Oldsection}

\let\Oldsubsection\subsection
\renewcommand{\subsection}{\FloatBarrier\Oldsubsection}

\let\Oldsubsubsection\subsubsection
\renewcommand{\subsubsection}{\FloatBarrier\Oldsubsubsection}
%---------------------------------------

\usepackage{graphicx}
\graphicspath{{images/}{images/}} 
\usepackage{float}
\usepackage{pgfplotstable}
\usepackage{pgfplots}
\pgfplotsset{compat=1.14}
\usepackage{setspace}
\usepackage[left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm]{geometry}
\usepackage{ifpdf}
\usepackage{pdfpages}
\usepackage[T1, T2A]{fontenc}
\usepackage[utf8]{inputenc}

\usepackage[english, ukrainian]{babel}
\usepackage{enumerate}
\usepackage{mathtools, amsmath, amsthm, amssymb, amsfonts}
\usepackage{multirow}
\usepackage{colortbl}
\RequirePackage{ifthen}
%\usepackage{ctable}
\usepackage{graphicx}
\usepackage[format=hang,labelfont=bf,font=small]{caption} 
\usepackage{xcolor}
\usepackage{color}
\definecolor{forestgreen}{RGB}{34,139,34}
\definecolor{orangered}{RGB}{239,134,64}
\definecolor{lightred}{rgb}{1,0.4,0.5}
\definecolor{orange}{rgb}{1,0.45,0.13}	
\definecolor{darkblue}{rgb}{0.0,0.0,0.6}
\definecolor{lightblue}{rgb}{0.1,0.57,0.7}
\definecolor{gray}{rgb}{0.4,0.4,0.4}
\definecolor{lightgray}{rgb}{0.95, 0.95, 0.95}
\definecolor{darkgray}{rgb}{0.4, 0.4, 0.4}
\definecolor{editorGray}{rgb}{0.95, 0.95, 0.95}
\definecolor{editorOcher}{rgb}{1, 0.5, 0} % #FF7F00 -> rgb(239, 169, 0)
\definecolor{chaptergrey}{rgb}{0.6,0.6,0.6}
\definecolor{editorGreen}{rgb}{0, 0.5, 0} % #007C00 -> rgb(0, 124, 0)
\definecolor{olive}{rgb}{0.17,0.59,0.20}
\definecolor{brown}{rgb}{0.69,0.31,0.31}
\definecolor{purple}{rgb}{0.38,0.18,0.81}
\usepackage{paralist}
\RequirePackage{helvet}

\usepackage{fancyhdr}
\pagestyle{fancy}
   \fancyhf{} 
%\renewcommand{\chaptermark}[1]{\markboth{\thechapter.\ #1}{}}
\fancyfoot[R]{\thepage} 
\fancyfoot[L]{\stud,\ \group} 
\fancyhead[R]{\subject}
\fancyhead[L]{\labreport}
\fancyhead[R]{\labtitle}

\renewcommand{\headrulewidth}{0.2pt}
\renewcommand{\footrulewidth}{0.2pt}
\addtolength{\headheight}{2pt}

\fancypagestyle{document}{%
	\fancyhead{}
    \fancyfoot[R]{\thepage} 
\renewcommand{\headrulewidth}{0.2pt}
\renewcommand{\footrulewidth}{0.2pt}
\addtolength{\headheight}{2pt}
}
%comandos
\def\@surname{}
\newcommand{\Surname}[1]{\def\@surname{#1}}
\newcommand{\surname}{\@surname}
\def\@name{}
\newcommand{\Name}[1]{\def\@name{#1}}
\newcommand{\name}{\@name}
\newcommand{\stud}{\@name\ \@surname}
\author{\@surname\ \@name}

\def\@group{}
\newcommand{\Group}[1]{\def\@group{#1}}
\newcommand{\group}{\@group}
\def\@yearofstudying{}
\newcommand{\YearOfStudying}[1]{\def\@yearofstudying{#1}}
\newcommand{\yearofstudying}{\@yearofstudying}
\def\@profesor{}
\newcommand{\Profesor}[1]{\def\@profesor{#1}}
\newcommand{\profesor}{\@profesor}
\def\@subject{}
\newcommand{\Subject}[1]{\def\@subject{#1}}
\newcommand{\subject}{\@subject}

\def\@labreport{}
\newcommand{\LabReport}[1]{\def\@labreport{#1}}
\newcommand{\labreport}{\@labreport}

\def\@labtitle{}
\newcommand{\LabTitle}[1]{\def\@labtitle{#1}}
\newcommand{\labtitle}{\@labtitle}

\def\@task{}
\newcommand{\Task}[1]{\def\@task{#1}}
\newcommand{\task}{\@task}

\def\@done{}
\newcommand{\Done}[1]{\def\@done{#1}}
\newcommand{\done}{\@done}

\usepackage{pgf}
\newcommand{\incluirpdf}[5]{
\includepdf[pages=#2,pagecommand={\subsection{#4}\label{#5}},scale=0.8]{#1}
\ifthenelse{\equal{#2}{#3}}{
	
	}{
    \pgfmathparse{int(round(#2+1))}
	\includepdf[pages={{\pgfmathresult}-#3},pagecommand={},scale=0.8]{#1}
}
}
\newcommand{\labReportSize}{\fontsize{15pt}{15pt}\selectfont}

\newcommand{\startDocument}{
\usepackage[unicode]{hyperref}
\hypersetup{colorlinks=true,
             citecolor=cyan,
             linkcolor=darkgray,
             urlcolor=teal,
             breaklinks=true,
             bookmarksnumbered=true,
             bookmarksopen=true,
             pdftitle={\labreport\ | \labtitle},
             pdfauthor={\stud},
             pdfcreator={\stud}
             }
\begin{document}
\maketitle
\dosecttoc
\faketableofcontents
}
\newcommand{\Tabla}[4]{
\begin{table}[H]
\centering
\caption{\bf #1 }
\begin{tabular}{#2}
#3
\end{tabular}
  \label{#4}
\end{table}
}




% #############################################################################
% CREATING THE TITLE PAGE (FRONTCOVER)
% #############################################################################
%
\setlength{\headheight}{16pt}

\renewcommand\maketitle{
\begin{titlepage}
\setstretch{1.1}
\thispagestyle{empty}%

\begin{center}
\vspace{-3cm}
{\MakeUppercase{Національний технічний університет України}}\\[1 mm]
{\MakeUppercase{``Київський політехнічний інститут імені Ігоря Сікорського''}}\\

\vspace{2cm}

\includegraphics[width=2.7cm]{./logo/LogoKPI}\\

\vspace{2cm}

\textbf{\Huge \subject}\par
 									\vskip 0.5cm
\rule[0.5ex]{\linewidth}{2pt}\\
            					    \vskip 0.5cm
\textbf{\LARGE \labtitle}\par
            					    \vskip 2cm
\textbf{\Large \task}\par
            					    \vskip 0.25cm
{\labReportSize \textbf{\Huge \labreport}\par}

\end{center}
					    \vskip 2cm
\begin{flushright}		                                    
\done \par
\textbf{\stud}\par
Група:\par
\textbf{\group}\par 
Курс:\par
\textbf{\yearofstudying}\par
\end{flushright}

					    \vskip 3cm
\begin{center}
{\large\today}
\end{center}

 \setstretch{1.5}
\end{titlepage}
  \setcounter{footnote}{0}
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
  \clearpage
}




\usepackage[nohints]{minitoc}
\def\stctitle{}
\setcounter{tocdepth}{3}
\setcounter{secttocdepth}{3}




\usepackage{listings}
\usepackage{textcomp}

\newcommand*\lstinputpath[1]{\lstset{inputpath=#1}}
\lstinputpath{./code}


\definecolor{comment}{RGB}{0,128,0} % dark green
\definecolor{string}{RGB}{255,0,0}  % red
\definecolor{keyword}{RGB}{0,0,255} % blue

\lstdefinestyle{c}{
	commentstyle=\color{comment},
	stringstyle=\color{string},
	keywordstyle=\color{keyword},
	basicstyle=\footnotesize\ttfamily,
	numbers=left,
	numberstyle=\tiny,
	numbersep=5pt,
	%frame=lines,
	breaklines=true,
	prebreak=\raisebox{0ex}[0ex][0ex]{\ensuremath{\hookleftarrow}},
	showstringspaces=false,
	upquote=true,
	tabsize=2,
}
\usepackage{tikz}
\usetikzlibrary{calc}
\newcommand*{\boxcolor}{red!30!green!10!orange}
\makeatletter
\renewcommand{\boxed}[1]{\textcolor{\boxcolor}{
\tikz[baseline={([yshift=-1ex]current bounding box.center)}] \node [rectangle, minimum width=1ex,rounded corners, draw, fill=lightgray] {\normalcolor\m@th$\displaystyle#1$};}}
\makeatother


\definecolor{gray}{gray}{0.5}
\colorlet{commentcolour}{green!50!black}

\colorlet{stringcolour}{red!60!black}
\colorlet{keywordcolour}{blue!90!black}
\colorlet{exceptioncolour}{yellow!50!red}
\colorlet{commandcolour}{blue!60!black}
\colorlet{numpycolour}{yellow!60!black}
\colorlet{literatecolour}{gray!80!white}
\colorlet{keywordcolour2}{magenta!80!black}
\colorlet{promptcolour}{green!50!black}
\colorlet{specmethodcolour}{violet}

\newcommand*{\framemargin}{3ex}

\newcommand*{\literatecolour}{\textcolor{literatecolour}}

\newcommand*{\pythonprompt}{\textcolor{promptcolour}{{>}{>}{>}}}

\lstdefinestyle{mypython}{
%\lstset{
keepspaces=true,
language=python,
numbers=left,
numberstyle=\tiny,
numbersep=5pt,
showtabs=true,
tab=,
tabsize=2,
basicstyle=\ttfamily\footnotesize,%\setstretch{.5},
stringstyle=\color{stringcolour},
showstringspaces=false,
alsoletter={1234567890},
otherkeywords={\%, \}, \{, \&, \|},
keywordstyle=\color{keywordcolour}\bfseries,
emph={and, class, def, global, in, lambda, not, or, pass, print, raise, try, while, assert, with},
%emphstyle=\color{blue}\bfseries,
emph={[2]True, False, None},
emphstyle=[2]\color{keywordcolour},
emph={[3]object,type,isinstance,copy,deepcopy,zip,enumerate,reversed,list,set,dict,tuple,xrange,append,add,execfile,real,imag,reduce,str,repr},
emphstyle=[3]\color{commandcolour},
emph={Exception,NameError,IndexError,SyntaxError,TypeError,ValueError,OverflowError,ZeroDivisionError},
emphstyle=\color{exceptioncolour}\bfseries,
upquote=true,
morecomment=[s]{"""}{"""},
commentstyle=\color{commentcolour}\slshape,
emph={[4]1, 2, 3, 4, 5, 6, 7, 8, 9, 0},
emph={[4]ode, fsolve, sqrt, exp, sin, cos,arctan, arctan2, arccos, pi,  array, norm, solve, dot, range,len, max, sum, flatten, shape, reshape, find, any, all, abs, plot, linspace, legend, quad, polyval,polyfit, hstack, concatenate,vstack,column_stack,empty,zeros,ones,rand,vander,grid,pcolor,eig,eigs,eigvals,svd,qr,tan,det,logspace,roll,min,mean,cumsum,cumprod,diff,vectorize,lstsq,cla,eye,xlabel,ylabel,squeeze},
emphstyle=[4]\color{numpycolour},
emph={[5]__init__,__add__,__mul__,__div__,__sub__,__call__,__getitem__,__setitem__,__eq__,__ne__,__nonzero__,__rmul__,__radd__,__repr__,__str__,__get__,__truediv__,__pow__,__name__,__future__,__all__},
emphstyle=[5]\color{specmethodcolour},
emph={[6]assert,yield},
emphstyle=[6]\color{keywordcolour}\bfseries,
emph={[7]range},
emphstyle={[7]\color{keywordcolour}\bfseries},
emph={[8] break, continue, yield, del, elif, else, except, exec, finally, for, from, if, import, return,},
emphstyle=[8]\color{keywordcolour2},
literate=*%
{:}{{\literatecolour:}}{1}%
{=}{{\literatecolour=}}{1}%
{-}{{\literatecolour-}}{1}%
{+}{{\literatecolour+}}{1}%
{*}{{\literatecolour*}}{1}%
{**}{{\literatecolour{**}}}2%
{/}{{\literatecolour/}}{1}%
{//}{{\literatecolour{//}}}2%
{!}{{\literatecolour!}}{1}%
%{(}{{\literatecolour(}}{1}%
%{)}{{\literatecolour)}}{1}%
%{[}{{\literatecolour[}}{1}%
%{]}{{\literatecolour]}}{1}%
{<}{{\literatecolour<}}{1}%
{>}{{\literatecolour>}}{1}%
{>>>}{\pythonprompt}{3},%
frame=trbl,
rulecolor=\color{black!40},
backgroundcolor=\color{lightgray!60!white},
breakindent=.5\textwidth,frame=single,breaklines=true%
}

\usepackage[customcolors, shade]{hf-tikz}
\hfsetbordercolor{orange}