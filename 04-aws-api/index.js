// create ZIP file: `zip lambda-hello-js.zip index.js`

console.log('lambda-hello-js: loading');

exports.handler = async (event, context) => {
    console.log('lambda-hello-js: running');
    
    const body = {
        message: 'hello from lambda-hello-js!',
        event,
        env: process.env,
    }
    
    const response = {
        statusCode: 201,
        body: JSON.stringify(body)
    }
    
    return response
};
