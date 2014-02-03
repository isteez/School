#include "TieBreaker.hpp"
#include "TieBreakerScore.hpp"
#include "Score.hpp"
#include "GameScore.hpp"
#include "PointScore.hpp"

TieBreaker::TieBreaker( Player *p1, Player *p2 ): Competition( p1, p2 ) {}

//  Implemented by David Wells
Score *TieBreaker::play( Player *p ) {
    TieBreakerScore *tieScore = new TieBreakerScore(player1(), player2() );
    tieScore -> addScore(reinterpret_cast<PointScore *>(p->serveAPoint())->getWinner() );
    p = p -> otherPlayer(p);
    bool switchTheServer = false;
    while( !tieScore -> haveAWinner() ) {
        tieScore -> addScore(reinterpret_cast<PointScore *>(p->serveAPoint())->getWinner() );
        if (switchTheServer) {
            p = p -> otherPlayer(p);
        }
        switchTheServer = !switchTheServer;
    }
    return tieScore;
}

