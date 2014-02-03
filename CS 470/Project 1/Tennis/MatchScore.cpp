#include "MatchScore.hpp"
#include "iostream"
#include "iomanip"
using namespace std;

MatchScore::MatchScore( Player *p1, Player *p2 ): Score( p1, p2 ), setNumber(0) {}

bool MatchScore::haveAWinner()  {
    return player1Score() == 3 || player2Score() == 3;
    
}

void MatchScore::addScore( Score *score ) {
    scores[setNumber] = reinterpret_cast<SetScore *>(score);
    setNumber++;
    score -> getWinner() == player1() ? p1Score++ : p2Score++;
}

void MatchScore::print() {
    cout << "   Set No.    Player A          Player B\n";
    for( int i = 0; i < setNumber; i++ ) {
        cout << setw(7) << i+1;
        scores[i]->print();
        cout << endl;
    }
    if ( player1Score() > player2Score() ) {
        cout << "\nPlayer A wins the match " << player1Score() << " sets to "
        << player2Score() << endl;
        cout << endl;
    }
    else{
        cout << "\nPlayer B wins the match " << player2Score() << " sets to "
        << player1Score() << endl;
        cout << endl;
    }
}

MatchScore::~MatchScore() {
    for( int i = 0; i < setNumber; i++ )
        delete scores[i];
}
