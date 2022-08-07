import React, {Component} from 'react'

class Message extends Component {
    render(){
        return <h3 id="userMessage">{this.props.text}</h3>;
    }
}

export default Message
