// create ZIP file: `zip lambda_function_payload.zip index.js`

console.log('potato - loading');

exports.handler = async (event, context) => {
    console.log('potato - running');
    
    const resp = {
        message: 'helo world!',
        event,
        env: process.env,
    }
    return JSON.stringify(resp, null, 2)
};
