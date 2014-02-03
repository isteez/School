#include "Set.hpp"
#include "Score.hpp"
#include "SetScore.hpp"
#include "Game.hpp"
#include "GameScore.hpp"
#include "PointScore.hpp"
#include "TieBreaker.hpp"
#include "TieBreakerScore.hpp"

Set::Set( Player *p1, Player *p2 ): Competition( p1, p2 ) {}

Score *Set::play( Player *p ) {
    SetScore *setScore = new SetScore(player1(), player2());
    while( !setScore -> haveAWinner()  ) {
        Game *game = new Game( player1(), player2() );
        Score *gameScore = game->play(p);
        setScore -> addScore( gameScore -> getWinner() );
        delete game;
        p = p->otherPlayer(p);
        if( setScore->shouldPlayATieBreaker() ) {
            TieBreaker *tiebreaker = new TieBreaker (player1(), player2() );
            setScore -> addTieScore( reinterpret_cast<TieBreakerScore *>(tiebreaker -> play(p)));
            return setScore;
        }
    }
    return setScore;
}
