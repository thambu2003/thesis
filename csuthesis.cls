% csuthesis class
% Designed by Leif Anderson to meet the bullshit
% requirements of the Colorado State University
% Graduate School for the formatting of theses
% and dissertations.  This document should comply
% with the requirements as of spring 2014, by the
% time it is completed.
% Much additional input provided by Dr. Dan Brake
% and... others to come

% Based on work by 
% Ankur Dave <ankurdave@gmail.com>
% in 2009
% Licensed under the CC-GNU GPL version 2.0 or later.
% See http://creativecommons.org/licenses/GPL/2.0

\ProvidesClass{csuthesis}

\LoadClass[12pt, oneside]{amsbook}
%this is basically going to be a class wrapper that takes amsbook and
% changes the formatting as little as possible to make it conform to 
% the dumber, uglier CSU standards.


% \DeclareOption{masters}{%
%   \@phdfalse
% }
% more here later.

% fields that user can set (in addition to title, author, etc)

% \newcommand{\committeeand}{\\ \>}
% \newcommand{\committee}[2][]{%
% 	\ifx\@empty\committees
% 		\gdef\committees{#2}%
% 	\else
% 		\g@addto@macro\committees{\committeeand#2}%
% % 		\g@addto@macro\addresses{\committee{}}%
% 	\fi
% 	\@ifnotempty{#1}{%
% 		\ifx\@empty\shortcommittees
% 			\gdef\shortcommittees{#1}%
% 		\else
% 			\g@addto@macro\shortcommittees{\committeeand#1}%
% 		\fi
% 	}%
% }
% \edef\committee{\@nx\@dblarg
% 	\@xp\@nx\csname\string\committee\endcsname}
% \let\shortcommittees\@empty \let\committees\@empty


\makeatletter

	\newcommand{\committee}[1]{\gdef\@committee{\xandlist{\\ \> }{ and }{\\ \>}{#1}}}%
	\newcommand{\@committee}{\@latex@warning@no@line{No \noexpand\committee given}}%
	
	% \addtoiargdef{\committee}{%
	%   \begingroup\let\footnote\@gobble}{%
	%   \begingroup
	%     \renewcommand{\and}{\unskip, }
	%   \endgroup\endgroup}
	% ^using that command group totally didn't work. Maybe \addto@argdef?

	% consider an ovverwrite of \and that has the single-spacing requirement written in, like \ignoredoublespace
	% if such a thing exists.
	
	\def\author#1{\gdef\@author{#1}}%
	\def\@author{\@latex@warning@no@line{No \noexpand\author given}}
	\def\departmentname#1{\gdef\@departmentname{#1}}
	\def\gradterm#1{\gdef\@gradterm{#1}}
	\def\advisor#1{\gdef\@advisor{#1}}
	\def\coadvisor#1{\gdef\@coadvisor{#1}}
	\def\copyrighttext#1{\gdef\@copyrighttext{#1}}
\makeatother

% \makeatletter
% 	\newcommand{\candidatenum}[1]{\def \@candidatenum {#1}}
% 	\newcommand{\subtitle}[1]{\def \@subtitle {#1}}
% 	\newcommand{\subject}[1]{\def \@subject {#1}}
% 	\newcommand{\wordcount}[1]{\def \@wordcount {#1}}
% 	\newcommand{\email}[1]{\def \@email {#1}}
% 	\newcommand{\departmentname}[1]{\def \@deptartmentname {#1}}
% 	\candidatenum{}
% 	\subtitle{}
% 	\subject{}
% 	\wordcount{}
% 	\email{}
% 	\departmentname{}
% \makeatother

% margins
\usepackage[top=1in,bottom=1in,left=1in,right=1in]{geometry}
% \usepackage[top=.8125in,bottom=.8125in,left=.8125in,right=.8125in]{geometry}

% \usepackage{pdflscape}
\usepackage[pdftex]{lscape}
\usepackage{float}
\usepackage{afterpage}
\usepackage{setspace}
\usepackage{environ}
\usepackage{arrayjobx}
\usepackage{verbatim}
\usepackage{wrapfig}
\usepackage{setspace}

\usepackage[font=singlespacing]{caption}
\graphicspath{{images/}}
\usepackage{amsmath}
\makeatletter
% \newenvironment{sidewayspage}{
% % 	\csname \afterpage{ \endcsname
% %		\clearpage
% 	\begin{landscape}
% 	\thispagestyle{empty}
% % 	\begin{table}[p]
% }{
% % 	\end{table}
% 	~\vfill\centerline{\footnotesize\thepage}
% 	\end{landscape}
% % 	\csname } \endcsname
% }
% \newenvironment{sidewayspage}{
% % 	store shit in a box
% \newsavebox{\tempboxside}
% \begin{lrbox}{\tempboxside}\begin{minipage}{\textheight}
% }{
% \end{minipage}\end{lrbox}
% % 	Write the box into the output
% \afterpage{
% 	\clearpage
% 	\begin{landscape}
% 	\thispagestyle{empty}
% % 	dump box here
% 	\usebox{\tempboxside}
% 	~\vfill\centerline{\footnotesize\thepage}
% 	\end{landscape}
% 	}
% }

% \newenvironment{sidewayspage}{
% % 	store shit in a box
% \newsavebox{\tempboxside}
% \begin{lrbox}{\tempboxside}
% }{
% \end{lrbox}
% % 	Write the box into the output
% \afterpage{
% 	\clearpage
% 	\begin{landscape}
% 	\thispagestyle{empty}
% % 	\begin{table}[!h]
% % 	dump box here
% 	\usebox{\tempboxside}
% % 	\end{table}
% 	~\vfill\centerline{\footnotesize\thepage}
% 	\end{landscape}
% 	}
% }

\NewEnviron{sidewayspage}{
	\def\tempreacharound{\clearpage\begin{landscape}\thispagestyle{empty}~\vfill}
	\expandafter\expandafter\expandafter\afterpage\expandafter\expandafter\expandafter{\expandafter\tempreacharound % DON'T EVEN ASK
	% the \BODY command loses its meaning if it is used inside another environment... sometimes.  Trust me, we need to do this.
	% More to the point, the whole afterpage thing makes this landscape page a floating page.
	% the \clearpage empties out the other floats.  Then \thispagestyle clears the page number from the old bottom
	\BODY
	% consider making the sidewayspage environment more of a table wrapper, with \captionof{table}{.... caption ...\label{table:sideways}}
	~\vfill\centerline{\footnotesize\thepage}%this puts the page number back in, but over on the side.
	%there could be problems here if the user changes page number sizes or something.  This one will not change automatically.
	\end{landscape}}
}

% \NewEnviron{sidewayspage}{%
% \afterpage{\clearpage\begin{landscape}\thispagestyle{empty} \BODY ~\vfill\centerline{\footnotesize\thepage}\end{landscape}}
% }

% \newfloat{sidewayspage}{p}{aux}[table]
% \floatname{sidewayspage}{Table}
\makeatother

% spacing
% it's taken some tinkering to get the spacing to work out correctly.
% I think that some commands are designed to work in the body, or in
% the actual header, so that when included here, they fail.
\usepackage{setspace}
% \doublespace
% \setstretch{1.66}
\setstretch{2}
% \usepackage{doublespace}

% references
% \usepackage{varioref}

% figures
\usepackage[pdftex]{graphicx}

% bibliography
\usepackage[square,sort,comma,numbers]{natbib} %better placed at the document level?

% page headings and numbering
\makeatletter
% 	\usepackage{fancyhdr}
% 	\pagestyle{fancy}
% % 	\renewcommand{\footrulewidth}{\headrulewidth} %this would put a line across the footer.
% 	\renewcommand{\headrulewidth}{0pt} %eliminates the default line across the header
% 	\fancyhf{} %clears the header and footer
% 	\fancyfoot[C]{\thepage} % places the page number, centered, in the footer.
% 	% \makeatletter \pagestyle{plain} or something similar may have worked more effeciently.
	\pagestyle{plain}
\makeatother


%%%%%%%%%%%%%%%%%%%%%%%%
%
%           customizing the table of contents appearance
%
%%%%%%%%%%%%%%%%%%%%%%

% \setcounter{tocdepth}{2}  %limits how deep sections are listed in the ToC, and how far they are numbered in the body.
   %  1 goes to sections, 2 to subsections, etc.

% See the ams manual thing, page 40 or so, for the beginning of the section, subsection, and table of contents formatting stuff.

\makeatletter
% \ifx\@tempa\undefined
% 	\def \@tempa {}
% \fi
% \ifx\@nil\undefined
% 	\def \@nil {}
% \fi
% \renewcommand{\contentsname}{\normalfont \normalsize \MakeUppercase{Table of Contents}}
% \renewcommand{\contentsname}{\MakeUppercase{Table of Contents}}
% \renewcommand{\listfigurename}{\MakeUppercase{List of Figures}}
% \renewcommand{\listtablename}{\MakeUppercase{List of Tables}}
% \renewcommand{\bibname}{\MakeUppercase{Bibliography}}
% \renewcommand{\indexname}{\MakeUppercase{Index}}
\renewcommand{\contentsname}{{\scshape Table of Contents}}
\renewcommand{\listfigurename}{{\scshape List of Figures}}
\renewcommand{\listtablename}{{\scshape List of Tables}}
\renewcommand{\bibname}{{\scshape Bibliography}}
\renewcommand{\indexname}{{\scshape Index}}
% \def\tableofcontents{%
%   \@starttoc{toc}\contentsname
% }
% \def\@makechapterhead#1{\global\topskip 7.5pc\relax %redefined not to have space.
\def\@makechapterhead#1{\global\topskip .625in\relax
  \begingroup
%   \fontsize{\@xivpt}{18}\bfseries\centering %from the rulebook: Do not use bold for preliminary page headings.
% I interpreted chapter headings as "preliminary page headings"
% addedthe scshape command here:
	\normalsize\normalfont\scshape\centering
    \ifnum\c@secnumdepth>\m@ne
      \leavevmode \hskip-\leftskip
      \rlap{\vbox to\z@{\vss
          \centerline{\normalsize\mdseries
              \uppercase\@xp{\chaptername}\enspace\thechapter}
          \vskip 3pc}}\hskip\leftskip\fi
     \Large#1\par \endgroup%added the \Large to make the chapter headings larger.  The word "chapter" is left alone, only the name of the chapter gets bigger.
  \skip@34\p@ \advance\skip@-\normalbaselineskip
  \vskip\skip@ }
% \def\@makeschapterhead#1{\global\topskip 7.5pc\relax
\def\@makeschapterhead#1{\global\topskip .625in\relax
  \begingroup
%   \fontsize{\@xivpt}{18}\bfseries\centering %from the rulebook: Do not use bold for preliminary page headings.
% I interpreted chapter headings as "preliminary page headings"
% added scshape here:
  \normalsize\normalfont\scshape\centering
  #1\par \endgroup
  \skip@34\p@ \advance\skip@-\normalbaselineskip
  \vskip\skip@ }
\def\@makescsuhead#1{\global\topskip 0pc\relax
  \begingroup
  \normalsize\normalfont\centering% this would be the "correct" spot to add smallcaps formatting, wouldn't it?
  #1\par~\\ \endgroup
  \skip@34\p@ \advance\skip@-\normalbaselineskip
  \vskip\skip@ }%this def is used just to make sure the table of contents name does not get bold faced or moved around
\def\@starttoc#1#2{%
  \begingroup
  \setTrue{#1}%
  \let\secdef\@gobbletwo \chapter
  \let\@secnumber\@empty % for \@tocwrite and \chaptermark
  \ifx\contentsname#2%
  \else \@tocwrite{chapter}{#2}\fi
  \typeout{#2}\@xp\chaptermark\@xp{#2}%
%   \@makeschapterhead{#2}\@afterheading %this writes the TABLE OF CONTENTS header, since this function is called with #2 as \contentsname.
	\@makescsuhead{#2}\@afterheading
  \parskip\z@skip
  \makeatletter
  \@input{\jobname.#1}%
  \if@filesw
    \@xp\newwrite\csname tf@#1\endcsname
    \immediate\@xp\openout\csname tf@#1\endcsname \jobname.#1\relax
  \fi
  \global\@nobreakfalse \endgroup
  \newpage
}
% \renewcommand{\section}{\@startsection
% {section}%                   % the name
% {1}%                         % the level
% {0mm}%                       % the indent
% {\baselineskip}%            % the before skip
% {0.5\baselineskip}%          % the after skip
% {\normalfont\centering}} % the style
\def\section{\@startsection{section}{1}%
  \z@{.7\linespacing\@plus\linespacing}{.5\linespacing}%
  {\normalfont\scshape\centering}} %writes the section headings in smallcaps, centered.
\def\subsection{\@startsection{subsection}{2}%
  \normalparindent{.5\linespacing\@plus.7\linespacing}{-.5em}%
  {\normalfont\scshape}}%writes the subsection headings in smallcaps.
\def\subsubsection{\@startsection{subsubsection}{3}%
  \normalparindent\z@{-.5em}%
  {\normalfont\itshape}}%sub sub sections are italics.
\renewcommand{\thesection}{\arabic{chapter}.\arabic{section}}%displays sections as 1.1, 1.2, etc rather than 1, 2, etc.

% \renewcommand{\bibsection}{%
% }
% \renewcommand\bibsection{\chapter*{\bibname}}{}%existing command
\renewcommand\bibsection{\centering\bibname \addcontentsline{toc}{chapter}{{\scshape \bibname}} ~\\ ~\\}{}% seems like this sort of overwrite 
% is the better spot to make formatting changes, rather than at the \bibname level.  uppercase was a name change, but smallcaps is a font change.
% we may be setting \scshape twice.  Not that it really matters.
% \renewcommand{\listfigurename}{\normalfont \normalsize \MakeUppercase{List of Figures}}
% \renewcommand{\listtablename}{\normalfont \normalsize \MakeUppercase{List of Tables}}
% \renewcommand{\bibname}{\normalfont \normalsize BIBLIOGRAPHY}
% \renewcommand{\indexname}{\vspace{9mm plus 0mm minus 0mm} \hfill \centering \normalfont \normalsize INDEX \hfill}
% \thm@headfont{\normalfont}
\makeatother

% \makeatletter
% \newcommand\contentsnamefont{\upshape}
% \newcommand\contentsnamefont{\mdseries}
% \makeatother


% \usepackage{titletoc}

% DO NOT USE titletoc.
% It may be powerful, but the documentation is terrible
% and it requires too much work to understand all the 
% different arguments that get passed to the commands.

% \titlecontents{section} % set formatting for \section -
% 	                    % \subsection must be formatted separately 
% [2.3em]                 % adjust left margin
% {\rmfamily}             % font formatting
% {\contentslabel{2.3em}} % section label and offset
% {\hspace*{-2.3em}}
% {\titlerule*[1pc]{.}\contentspage}

% Dan's TOC solution:  (doesn't interact well with amsbook)
% \usepackage{tocloft}  %import the package  (Table of Contents)
% \renewcommand{\cftchapfont}{\normalfont}    %make chapter listings in ToC have normal font (not bold)
% \renewcommand\cftchappagefont{\normalfont}   %make chapter listings in ToC have normal font (not bold)
% \renewcommand{\cftchapleader}{\cftdotfill{\cftsecdotsep}}  %make sure chapters get dots, as per graduate school
% \renewcommand{\cftsecfont}{\normalfont}     
% \renewcommand{\cftfigfont}{Figure }
% \renewcommand{\cfttabfont}{Table }  %leave the trailing space
% 
% \cftsecindent 2em %indentations in em's.  the size of an em changes depending on the font you choose
% \cftsubsecindent 4em
% 
% \renewcommand{\cftpartdotsep}{\cftdotsep}  %force dots  between parts, chapters, & page numbers
% \renewcommand{\cftchapdotsep}{\cftdotsep}
% 
% 
% \renewcommand{\contentsname}{\vspace{-26.5mm plus 0mm minus 0mm} \hfill\normalsize \normalfont \centering TABLE OF CONTENTS \hfill}
% \renewcommand\listfigurename{\vspace{-27.25mm plus 0mm minus 0mm} \hfill \centering \normalfont \normalsize LIST OF FIGURES \hfill}
% \renewcommand{\bibname}{\vspace{3.25mm plus 0mm minus 0mm} \hfill \centering \normalfont \normalsize BIBLIOGRAPHY \hfill}
% \renewcommand{\indexname}{\vspace{9mm plus 0mm minus 0mm} \hfill \centering \normalfont \normalsize INDEX \hfill}

%dotted line for TOC.  This is the definition of \@tocline, copied out of amsbook.
\makeatletter
\def\@tocline#1#2#3#4#5#6#7{\relax
  \ifnum #1>\c@tocdepth % then omit
  \else
    \par \addpenalty\@secpenalty\addvspace{#2}%
    \begingroup \hyphenpenalty\@M
    \@ifempty{#4}{%
      \@tempdima\csname r@tocindent\number#1\endcsname\relax
    }{%
      \@tempdima#4\relax
    }%
    \parindent\z@ \leftskip#3\relax \advance\leftskip\@tempdima\relax
    \rightskip\@pnumwidth plus4em \parfillskip-\@pnumwidth
    #5\leavevmode\hskip-\@tempdima #6\nobreak\relax
%     \hfil\hbox to\@pnumwidth{\@tocpagenum{#7}}\par % this was the original line.
    \dotfill\hbox to\@pnumwidth{\@tocpagenum{#7}}\par % the dotfill makes a dotted line across to the page number.
    \nobreak
    \endgroup
  \fi}
\makeatother

%%%%%%%%%%%%%
% title
%%%%%%%%%%%%%

%required stuff:
% 1 inch margins all sides, no bold, no titles on committee
% centered:
% Top line: 
% DISSERTATION (all caps)
% some space
% TITLE IN ALL CAPS AND DOUBLESPACED \MakeUppercase{} will be useful.
% some space
% Submitted by
% blank line
% \@author
% blank line
% \@departmentname
% some space
% In partial fulfullment of the requirements 
% blank line
% For the degree of Doctor of Philosophy
% blank line
% Colorado State University
% blank line
% Fort Collins, Colorado
% blank line
% \@gradterm
% end center
% left align:
% Doctoral Committee:
% blank line
% Indent, still left:
% Advisor: \@advisor
% Co-Advisor: \@coadvisor (if the coadvisor exists)
% blank line
% committee member list (no titles attached anywhere)
% NO PAGE NUMBER ON THIS PAGE but it is page 1 of frontmatter (so page i, unlabeled)

\makeatletter
\renewenvironment{abstract}{%
	\ifx\maketitle\relax
		\ClassWarning{\@classname}{Abstract should precede
			\protect\maketitle\space in CSU Thesis document class; reported}%
	\fi
	\global\setbox\abstractbox=\vtop \bgroup
% 		\normalfont\Small
% 		\list{}{\labelwidth\z@
% 			\leftmargin3pc \rightmargin\leftmargin
% 			\listparindent\normalparindent \itemindent\z@
% 			\parsep\z@ \@plus\p@
% 			% In order to get equation numbers indented with the rest of the abstract, we have to do this:
% 			\let\fullwidthdisplay\relax
% 		}%
% 	\item[\hskip\labelsep\scshape\abstractname.]%
	% Instead of a list, with associated nice formatting, I will just dump the word abstract and the title
	% in ALL CAPS BECAUSE OF CSU FORMATTING RULES, which I think is dumb, but I don't make the rules.
% 	\begin{center}\begin{singlespace}\MakeUppercase{Abstract}\\ ~\\\end{singlespace}
	\begin{center}\begin{singlespace}{\scshape Abstract}\\ ~\\\end{singlespace}
% 	\MakeUppercase{\@title}
	{\scshape \@title}
	\end{center}%blank line below here so the abstract starts indented.
	
}{%
\endlist\egroup
% If the abstract was supposed to be typeset earlier, then \@setabstract is now equal to \relax, and we had better drop the contents of the abstract box onto the page immediately, to salvage the situation as best we can.
\ifx\@setabstract\relax \@setabstracta \fi
}
% % Because the abstract might be postponed until the end of an article, we can-not simply use the fact of a preceding \maketitle to tell whether \endabstract should immediately put the abstract box contents on the page. So we use an auxiliary function that will be reset to no-op once we have passed the point where the abstract should normally be typeset.
% This part should still be intact in the amsbook class.
% \def\@setabstract{\@setabstracta \global\let\@setabstract\relax}
% \def\@setabstracta{%
% \ifvoid\abstractbox
% \else
% 	\skip@20\p@ \advance\skip@-\lastskip
% 	\advance\skip@-\baselineskip \vskip\skip@
% 	\box\abstractbox
% 	\prevdepth\z@ % because \abstractbox is a vtop
% \fi
% }
% the acknowledgements will basically be a copy of the abstract.
\newbox\ackbox
\newenvironment{acknowledgements}{%
  \ifx\maketitle\relax
    \ClassWarning{\@classname}{Acknowledgements should precede
      \protect\maketitle\space in the csuthesis class; reported}%
  \fi
  \global\setbox\ackbox=\vtop \bgroup
%     \begin{center}\MakeUppercase{Acknowledgements}\end{center}
	\begin{center}{\scshape Acknowledgements}\end{center}
}{%
	Great thanks are also due to Leif Anderson for building this \LaTeX\ document class, allowing me to meet the graduate school formatting requirements with no effort on my part. % You're welcome.
  \endlist\egroup
  \ifx\@setack\relax \@setacka \fi
}
\def\@setack{\@setacka \global\let\@setack\relax}
\def\@setacka{%
  \ifvoid\ackbox
  \else
    \skip@20\p@ \advance\skip@-\lastskip
    \advance\skip@-\baselineskip \vskip\skip@
    \box\ackbox
    \prevdepth\z@ % because \abstractbox is a vtop
  \fi
}
%Now we overwrite \maketitle
%the original had a lot more error handling, which I have ignored here.
% Our \maketitle will be huge, and will do everything needed at the beginning: title page, abstract, acknowledgements, copyright, etc.
\def \maketitle {%
	\begin{titlepage}
		\begin{center}
			\MakeUppercase{Dissertation}
% 			{\large\scshape Dissertation}
% 			\textsc{Dissertation}
			~\vfill
% 			\begin{doublespace}
% 			{\MakeUppercase{\@title}}
			{\large\scshape \@title}
% 			\end{doublespace}
% 			I think subtitles are not allowed.
% 			\ifx \@subtitle \@empty
% 				\relax
% 			\else
% 				\vspace{0.5em}
% 				{\large \@subtitle} \\
% 			\fi
			~\vfill
			Submitted by \\
% 			~\\
% 			blank line
			\ifx @author \@empty
				\relax
			\else
				\@author \\
			\fi
% 			\@author
% % 			blank line
% 			~\\
			\@departmentname
% % 			some space
			~\vfill
			In partial fulfullment of the requirements \\
			For the Degree of Doctor of Philosophy \\ % The inconsistent capitalization between this line and the previous is required by the graduate school.
			Colorado State University \\
			Fort Collins, Colorado \\
			\@gradterm
			~\vfill
		\end{center}
		% left align:
		\begin{singlespace}
		Doctoral Committee:\\
		% blank line
		\begin{tabbing}
		\hspace*{0.5in}\=
		% Indent, still left:
		Advisor: \@advisor \\ \>
		% Co-Advisor: \@coadvisor (if the coadvisor exists)
		\ifx\@coadvisor\undefined
			\relax
		\else
% 			\hspace*{0.5in}Co-Advisor: \@coadvisor \\
			Co-Advisor: \@coadvisor \\
		\fi
		% blank line
		~\\ \> %the extra \> moves back to the right tab stop, which the ~\\ will have dropped.
		% committee member list (no titles attached anywhere)
% 		\hspace*{0.5in}\@committee
		\@committee
		\end{tabbing}
		\end{singlespace}
	\end{titlepage}
	\ifx\@copyrighttext\undefined
		\relax
	\else
		% Make a copyright page
		\thispagestyle{empty}
		\vspace*{\fill}
		\begin{center}
		\@copyrighttext
		\end{center}
		\vspace*{\fill}
		\clearpage
	\fi
	\setcounter{page}{2} %the copyright page is not assigned a number nor counted
	\unvbox\abstractbox
% 	\addcontentsline{toc}{chapter}{\MakeUppercase{Abstract}}
	\addcontentsline{toc}{chapter}{{\scshape Abstract}}
	% Acknowledgements
	\ifvoid\ackbox
	\else
		\clearpage
		\unvbox\ackbox
% 		\addcontentsline{toc}{chapter}{\MakeUppercase{Acknowledgements}}
		\addcontentsline{toc}{chapter}{{\scshape Acknowledgements}}
	\fi
}

\makeatother

% Dan's abstract solution:
% \renewcommand{\abstract}{
% \makeatletter
% % \let\originalabstractcall=\abstract
% % \def \abstract {%
% \renewcommand{\abstract}{
% % 	\newpage\null\vspace*{ -14mm plus0mm minus0mm}  %adjust the ABSTRACT word up to the top.
% 	\begin{center}
% 	{\MakeUppercase{Abstract}} \\
% % 	[\baselineskip]\uppercase\expandafter{\Ztitle}
% 	{\MakeUppercase{\@title}}
% 	\end{center}
% 	%\vskip 20pt plus 2pt minus 2pt
% }
% \makeatother

% Copied from the ftp://ftp.ams.org/ams/amslatex/classes/amsclass.pdf, page 33/34:
% In AMS document classes, the abstract should be placed before \maketitle
% (otherwise the desired ordering of frontmatter elements cannot be ensured in all
% cases).
% 897 \newbox\abstractbox
% We start by checking whether \maketitle has already been used (in which case
% it was reset to \relax); if so, we give a warning that the abstract should be
% placed before \maketitle.
% 898 \newenvironment{abstract}{%
% 899 \ifx\maketitle\relax
% 900 \ClassWarning{\@classname}{Abstract should precede
% 901 \protect\maketitle\space in AMS document classes; reported}%
% 902 \fi
% 903 \global\setbox\abstractbox=\vtop \bgroup
% 904 \normalfont\Small
% 905 \list{}{\labelwidth\z@
% 906 \leftmargin3pc \rightmargin\leftmargin
% 907 \listparindent\normalparindent \itemindent\z@
% 908 \parsep\z@ \@plus\p@
% In order to get equation numbers indented with the rest of the abstract, we have
% to do this:
% 909 \let\fullwidthdisplay\relax
% 910 }%
% 911 \item[\hskip\labelsep\scshape\abstractname.]%
% 912 }{%
% 913 \endlist\egroup
% If the abstract was supposed to be typeset earlier, then \@setabstract is now
% equal to \relax, and we had better drop the contents of the abstract box onto
% the page immediately, to salvage the situation as best we can.
% 914 \ifx\@setabstract\relax \@setabstracta \fi
% 915 }
% Because the abstract might be postponed until the end of an article, we can-
% not simply use the fact of a preceding \maketitle to tell whether \endabstract
% should immediately put the abstract box contents on the page. So we use an
% auxiliary function that will be reset to no-op once we have passed the point
% where the abstract should normally be typeset.
% 916 \def\@setabstract{\@setabstracta \global\let\@setabstract\relax}
% 917 \def\@setabstracta{%
% 918 \ifvoid\abstractbox
% 919 \else
% 920 \skip@20\p@ \advance\skip@-\lastskip
% 921 \advance\skip@-\baselineskip \vskip\skip@
% 922 \box\abstractbox
% 923 \prevdepth\z@ % because \abstractbox is a vtop
% 924 \fi
% 925 }
% Title page environment does nothing much; information and formatting to
% be provided by the user.
% 926 \def\titlepage{%
% 927 hamsbooki \cleardoublepage
% 928 hamsart j amsproci \clearpage
% 929 \thispagestyle{empty}\setcounter{page}{0}}
% 930 \def\endtitlepage{\newpage}


% \makeatletter
% \usepackage[compact]{titlesec}
% 
% % \titleformat{\chapter}[display]  %display gives the two-line effect
% % 	{\vspace{0mm plus 0mm minus 0mm} \normalfont \normalsize \filcenter}%\Large
% % 	{\MakeUppercase{\chaptertitlename}\  \thechapter:}
% % 	{1em}
% % 	{}
% % 	{  \normalsize}
% 
% \titleformat{\section}[block]  %block gives one line headings 
% 	{\normalfont \normalsize \filcenter } %\large \normalsize
% 	{\thesection.}
% 	{1em}
% 	{}
% 	{\normalsize}
% 	
% \titleformat{\subsection}[block]
% 	{\scshape \normalsize \filcenter }
% 	{ \thesubsection }
% 	{1em}
% 	{}
% 	{  \normalsize}
% 		
% \titleformat{\subsubsection}[block]
% 	{\normalfont \normalsize \filcenter }
% 	{ \thesubsubsection }
% 	{1em}
% 	{}
% 	{  \normalsize}
% 	
% \titleformat{\paragraph}[block]
% 	{\bfseries \normalsize \hspace{1cm} }
% 	{ \theparagraph }
% 	{0pt}
% 	{}
% 	{ \normalsize}
% \makeatother