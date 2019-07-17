import React from "react";
import _orderBy from "lodash/orderBy";
import _find from "lodash/find";
import { Route } from "react-router-dom";
import GamesList from "./GamesList";
import GameForm from "./GameForm";
import api from "../api";

const publisher = [
  {
    _id: "1",
    name: "Days of Wonder"
  },
  {
    _id: "2",
    name: "Rio Grande Games"
  }
];

class GamesPage extends React.Component {
  state = {
    games: [],
    selectedGame: {},
    loading: true
  };

  componentDidMount() {
    api.games
      .fetchAll()
      .then(games =>
        this.setState({ games: this.sortGames(games), loading: false })
      );
  }

  sortGames(games) {
    return _orderBy(games, ["featured", "name"], ["desc", "asc"]);
  }

  toggleFeatured = gameID => {
    const game = _find(this.state.games, { _id: gameID });
    return this.updateGame({
      ...game,
      featured: !game.featured
    });
  };

  descriptionToggle = gameID =>
    this.setState({
      games: this.sortGames(
        this.state.games.map(game =>
          gameID === game._id
            ? { ...game, descriptionVisible: !game.descriptionVisible }
            : game
        )
      )
    });

  saveGame = game => (game._id ? this.updateGame(game) : this.addGame(game));

  addGame = gameData =>
    api.games.create(gameData).then(game =>
      this.setState({
        games: this.sortGames([...this.state.games, game]),
        showGameForm: false
      })
    );

  updateGame = gameData =>
    api.games.update(gameData).then(game =>
      this.setState({
        games: this.sortGames(
          this.state.games.map(item => (item._id === game._id ? game : item))
        ),
        showGameForm: false
      })
    );

  selectGameForEditing = game =>
    this.setState({ selectedGame: game, showGameForm: true });

  deletingGame = game =>
    api.games.delete(game).then(() =>
      this.setState({
        games: this.state.games.filter(item => item._id !== game._id)
      })
    );

  render() {
    const numberOfColumns =
      this.props.location.pathname === "/games" ? "sixteen" : "ten";

    return (
      <div className="ui container">
        <div className="ui stackable grid">
          <Route
            path="/games/new"
            render={() => (
              <div className="six wide column">
                <GameForm
                  publisher={publisher}
                  submit={this.saveGame}
                  game={{}}
                />
              </div>
            )}
          />

          <div className={`${numberOfColumns} wide column`}>
            {this.state.loading ? (
              <div className="ui icon message">
                <i className="notched circle loading icon" />
                <div className="content">
                  <div className="header">Wait a second!</div>
                  <p>Loading games collection...</p>
                </div>
              </div>
            ) : (
              <GamesList
                games={this.state.games}
                toggleFeatured={this.toggleFeatured}
                descriptionToggle={this.descriptionToggle}
                editGame={this.selectGameForEditing}
                deleteGame={this.deletingGame}
              />
            )}
          </div>
        </div>
      </div>
    );
  }
}

export default GamesPage;
