import React, {Component} from 'react'
import Entry from './Entry'

class Word extends Component {
    render(){
        return(
            <div>
                <h2 id="wordName">{this.props.name}</h2>
                {this.props.entries.map(entry => <Entry function={entry.function} definitions={entry.definitions} />)}
            </div>
        );
    }
}

export default Word
