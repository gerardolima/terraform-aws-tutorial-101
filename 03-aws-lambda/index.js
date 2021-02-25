// create ZIP file: `zip lambda-hello-js.zip index.js`

console.log('lambda-hello-js: loading');

exports.handler = async (event, context) => {
    console.log('lambda-hello-js: running');
    
    const resp = {
        message: 'hello from lambda-hello-js!',
        event,
        env: process.env,
    }
    return JSON.stringify(resp, null, 2)
};
