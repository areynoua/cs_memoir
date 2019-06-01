:inoremap APN \ac{PN}
:inoremap APNS \acp{PN}
:inoremap APPN \ac{PPN}
:inoremap APPNS \acp{PPN}
:inoremap AWSTS \ac{WSTS}
:inoremap AWSTSS \acp{WSTS}
:inoremap AEEC \ac{EEC}
:inoremap KM<space> Karp and Miller<space>
:inoremap KMA<space> Karp and Miller algorithm<space>
:inoremap \m1 \mar_1
:inoremap \m2 \mar_2
:inoremap \mp \marp
:inoremap prblm<space> problem<space>
:inoremap cp<space> coverability problem<space>
:inoremap algo<space> algorithm<space>
:inoremap algos<space> algorithms<space>
:inoremap iscs<space> increasing self-covering sequence<space>
:inoremap scs<space> self-covering sequence<space>
:inoremap ITE \begin{itemize}o\end{itemize}O\item<space>
:inoremap ENU \begin{enumerate}o\end{enumerate}O\item<space>
:inoremap THEO \begin{theo}o\end{theo}O\label{}itheo:
:inoremap -<space><space> \item<space>

:let @s='v%c{}Px%lxh%l'
:let @c='v%c[]Px%lxh%l'
:let @p='v%c()Px%lxh%l'
:let @d='c{}P`<v`>ll'
:let @v='c[]P`<v`>ll'
:let @o='c()P`<v`>ll'
:let @f='il%hxI\setComplx:s/ \?\\mid \?/}{/^d0k$J'
:let @v='/\\vect\>de@p'
:let @g='/\\\(kmacc\|effect\|lab\|maxp\|maxs\|upc\|downc\|maxs\?\|minp\|op\|cover\|pres\?\|posts\?\)(lveguel@s'
:let @h='/\\\(inm\|matIS\|matOS\|inw\[t\]\|outw\[t\]\)(lgu el@c'

:set spell spelllang=en
