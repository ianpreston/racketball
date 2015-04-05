# racketball

Racketball is yet another Pong clone, written in Racket. It's an attempt at writing a game in pure functional style. Though the rendering and input logic is mostly imperative, the game update loop; entity behaviour, controls, "AI", scoring, etc are all pure functional.

## Install & run

There are no external dependencies beside Racket itself, so after cloning the git repo, just run:

    $ racket main.rkt

![Screenshot](https://ianpreston.io/racketball.png)

## License

Racketball is available under the [MIT License](http://opensource.org/licenses/MIT).
