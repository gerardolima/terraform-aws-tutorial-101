// create ZIP file: `zip hello_js.zip index.js`

console.log('hello_js: loading');

exports.handler = async (event, context) => {
    console.log('hello_js: running');

    const body = {
        message: 'hello from hello_js!',
        event,
        env: process.env,
    }

    const response = {
        statusCode: 200,            // << mandatory
        body: JSON.stringify(body)
    }

    return response
};
