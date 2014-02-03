#include "TieBreakerScore.hpp"
#include <stdlib.h>
#include <iostream>
#include <iomanip>

TieBreakerScore::TieBreakerScore( Player *p1, Player *p2 ): Score(p1, p2) {}

bool TieBreakerScore::haveAWinner(){
    return (player1Score() >= 7 || player2Score() >= 7)  && abs(player1Score() - player2Score() >=2 );
}

void TieBreakerScore::print() {
    std::cout << std::setw(16) << "(Tie Breaker  " << player1Score() << "-" <<
    player2Score() << ")";
}