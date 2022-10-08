import React, {Component} from 'react'
import Definition from './Definition'

class Entry extends Component {
    render(){
        return (
            <div>
                <em>{this.props.function}</em>
                <ul>
                    {this.props.definitions.map( definition => <Definition text={definition}/> )}
                </ul>
            </div>
        );
    }
}

export default Entry
