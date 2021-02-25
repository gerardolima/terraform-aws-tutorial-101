// create ZIP file: `zip hello-lambda-js.zip index.js`

console.log('hello-lambda-js: loading');

exports.handler = async (event, context) => {
    console.log('hello-lambda-js: running');
    
    const resp = {
        message: 'hello from hello-lambda-js!',
        event,
        env: process.env,
    }
    return JSON.stringify(resp, null, 2)
};
