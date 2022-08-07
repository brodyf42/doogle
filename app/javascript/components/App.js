import React, {Component} from 'react'
import SearchForm from './SearchForm'
import Word from './Word'
import Message from './Message'

const getApiContent = endpoint => fetch(endpoint).then(response => response.json());

class App extends Component {
    constructor(props){
        super(props);
        this.state = {
            data: null,
            message: "Please enter a word above to search for its definition",
            searchText: ''
        };
        this.handleSearchTextChange = this.handleSearchTextChange.bind(this);
        this.handleSearchFormSubmitted = this.handleSearchFormSubmitted.bind(this);
    }

    handleSearchTextChange(searchText){
        this.setState({ searchText: searchText});
    }

    handleSearchFormSubmitted(event){
        event.preventDefault();
        const searchText = this.state.searchText.trim();
        if (searchText === ''){
            this.setState({
                message: "The search form cannot be blank. Please try again.",
                data: null
            });
            return;
        }

        const api_endpoint = '/api/words/' + encodeURIComponent(searchText);

        getApiContent(api_endpoint)
        .then(result => {
            this.setState({
                message: result.message,
                data: result.data
            });
        })
        .catch(err => {
            this.setState({
                message: "An error occurred. Please try again.",
                data: null
            });
            console.log(err.message);
        });
    }

    render() {
        return(
            <div>
                <h1>Doogle App</h1>
                <SearchForm
                    searchText={this.state.searchText}
                    onSearchTextChange={this.handleSearchTextChange}
                    onFormSubmit={this.handleSearchFormSubmitted}
                />
                {this.state.message && <Message text={this.state.message}/>}
                {this.state.data && <Word name={this.state.data.name} entries={this.state.data.entries} />}
            </div>
        );
    }
}

export default App
