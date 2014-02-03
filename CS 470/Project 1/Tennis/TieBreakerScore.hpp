#ifndef _TieBreakerScore_hpp
#define _TieBreakerScore_hpp

#include "Score.hpp"
#include "Player.hpp"

class TieBreakerScore: public Score {
public:
    TieBreakerScore( Player *p1, Player *p2 );
    bool haveAWinner();
    void print();
    
};

#endif
