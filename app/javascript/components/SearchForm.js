import React, {Component} from 'react'

class SearchForm extends Component {
    constructor(props){
        super(props);
        this.handleSearchTextChange = this.handleSearchTextChange.bind(this);
    }

    handleSearchTextChange(event){
        this.props.onSearchTextChange(event.target.value);
    }

    render(){
        return(
            <form id="searchForm" onSubmit={this.props.onFormSubmit}>
                <input type="text"
                       placeholder="Enter word..."
                       value={this.props.searchText}
                       onChange={this.handleSearchTextChange}
                       id="searchField"
                />
                <input type="submit" value="Search" />
            </form>
        );
    }
}

export default SearchForm
