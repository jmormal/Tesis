\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{configuraciones/editorialupv}[2016/09/05 Editorial UPV]
\LoadClass[10pt]{book}

\RequirePackage{ifthen}
\RequirePackage{calc}

% Boolean flags
\newboolean{LLIBRE}\setboolean{LLIBRE}{false}
\newboolean{TESI}\setboolean{TESI}{false}
\newboolean{Aquatre}\setboolean{Aquatre}{false}
\newboolean{AquatreElectronic}\setboolean{AquatreElectronic}{false}
\newboolean{EBOOKPDF}\setboolean{EBOOKPDF}{false}
\newboolean{EPUB}\setboolean{EPUB}{false}
\newboolean{NotEPUB}\setboolean{EPUB}{true}
\newboolean{Literari}\setboolean{Literari}{false}
\newboolean{CROP}\setboolean{CROP}{false}
\newboolean{DistanciesEquacions}\setboolean{DistanciesEquacions}{true}
\newboolean{RM}\setboolean{RM}{false}
\newboolean{SF}\setboolean{SF}{false}
\newboolean{valencia}\setboolean{valencia}{false}
\newboolean{castellano}\setboolean{castellano}{false}
\newboolean{english}\setboolean{english}{false}

% Options
\DeclareOption{EPUB}{\setboolean{EPUB}{true}\setboolean{NotEPUB}{false}}
\DeclareOption{llibre}{\setboolean{LLIBRE}{true}}
\DeclareOption{tesi}{\setboolean{TESI}{true}}
\DeclareOption{a4}{\setboolean{Aquatre}{true}}
\DeclareOption{a4e}{\setboolean{AquatreElectronic}{true}}
\DeclareOption{ebookpdf}{\setboolean{EBOOKPDF}{true}\setboolean{LLIBRE}{false}}
\DeclareOption{crop}{\setboolean{CROP}{true}}
\DeclareOption{nocrop}{\setboolean{CROP}{false}}
\DeclareOption{rm}{\setboolean{RM}{true}}
\DeclareOption{sf}{\setboolean{SF}{true}}
\DeclareOption{nomathskip}{\setboolean{DistanciesEquacions}{false}}
\DeclareOption{castellano}{\setboolean{castellano}{true}}
\DeclareOption{valencia}{\setboolean{valencia}{true}}
\DeclareOption{english}{\setboolean{english}{true}}
\DeclareOption{literari}{\setboolean{Literari}{true}}
\DeclareOption*{\ClassWarning{editorialupv}{Unknown option: \CurrentOption}}
\ExecuteOptions{llibre,rm,nocrop,castellano}
\ProcessOptions\relax

% Formatting Logic
\ifdefined\HCode \setboolean{EPUB}{true} \fi

% Page Geometry
\RequirePackage{geometry}
\ifAquatre
    \geometry{a4paper, twoside, hmargin={3.0cm, 2.25cm}, vmargin={1.25cm, 1.25cm}, includehead, includefoot, headsep=1.0cm, footskip=1.5cm}
\else
    % Standard Book/Thesis size (17x24cm approx)
    \geometry{twoside, vmargin={1.75cm, 1.75cm}, left=2.5cm, textwidth=13cm, paperwidth=17cm, paperheight=24cm, includehead, includefoot} 
    \ifCROP \usepackage[cam, a4, center, odd, noinfo]{crop} \fi
\fi

% Fonts
\ifLLIBRE \renewcommand{\normalsize}{\fontsize{10.5pt}{12.5pt}\selectfont} \fi
\ifTESI \renewcommand{\normalsize}{\fontsize{10.5pt}{12.5pt}\selectfont} \fi
\ifSF \renewcommand{\familydefault}{\sfdefault} \else \renewcommand{\familydefault}{\rmdefault} \fi

% Headers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhead{} \fancyfoot{}
\fancyhead[LE]{\footnotesize\itshape\nouppercase\leftmark}
\fancyhead[LO]{\footnotesize\itshape\nouppercase\rightmark}
\fancyfoot[LE,RO]{\thepage}
\renewcommand{\headrulewidth}{0pt}

% Titles
\RequirePackage[raggedright, compact, nobottomtitles*, clearempty]{titlesec}
\titleformat{\chapter}[display]{\normalfont\Large\filcenter}{\raggedleft\fontsize{18}{20}\bfseries\chaptertitlename\enspace\thechapter}{2ex}{\raggedleft\fontsize{24}{30}\bfseries}[\vspace{2cm}]

% TOC
\RequirePackage[titles]{tocloft}
\setcounter{tocdepth}{1}

% Lists
\ifEPUB \else \RequirePackage{enumitem} \setlist{nosep} \fi

% Math spacing
\RequirePackage{mathtools}
\ifDistanciesEquacions
\AtBeginDocument{
    \abovedisplayshortskip = -1.0ex plus 0ex minus 0.25ex
    \belowdisplayshortskip = 2.0ex plus 1ex minus 0.0ex
    \abovedisplayskip = -1.0ex plus 0ex minus 0.25ex
    \belowdisplayskip = 2.0ex plus 1ex minus 0.0ex
}
\fi
