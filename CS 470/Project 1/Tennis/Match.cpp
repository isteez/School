#include "Match.hpp"
#include "MatchScore.hpp"
#include "Score.hpp"
#include "Set.hpp"
#include "Score.hpp"
#include "SetScore.hpp"

Match::Match( Player *p1, Player *p2 ): Competition( p1, p2 ) {}
Score *Match::play( Player *p ) {
    MatchScore *matchScore = new MatchScore( player1(), player2() );
    while ( !matchScore->haveAWinner() ) {
        Set *set = new Set( player1(), player2() );
        Score *setScore = set->play( player1() );
        matchScore -> addScore(setScore);
        delete set;
        p = p -> otherPlayer(p);
    }
    return matchScore;
}
