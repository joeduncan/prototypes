const { send } = require('micro');
const query = require('micro-query');
const url = require('url');
const config = require('./config');
const MongoClient = require('mongodb').MongoClient;

let theDb;

(async () => {
    const db = await MongoClient.connect(config.MONGO_HOST);
    theDb = db.db(config.MONGO_DB_NAME);
})()

module.exports = async (req, res) => {
    res.setHeader('Access-Control-Allow-Origin', '*')
    const q = query(req);
    const endpoint = url.parse(req.url);

    if (endpoint.pathname.endsWith('/healthcheck')) {
        return 'OK';
    }

    if (endpoint.pathname.endsWith('/image')) {
        const image = await theDb.collection('images')
            .aggregate([
                { $sample: { size: 1 } }
            ]).next();

        return image;
    }

    if (endpoint.pathname.endsWith('/score')) {
        await theDb.collection('scores').updateOne({
            image: q.image,
            session: q.session
        },
            {
                $set: {
                    score: parseInt(q.score, 10)
                }
            },
            {
                upsert: true,
            });

        return { status: 'OK' };
    }

    if (endpoint.pathname.endsWith('/collect')) {
        const result = await theDb.collection('scores').aggregate([
            { $group: {
                _id: { image: '$image', score: '$score' },
                sum: { $sum: 1 }
            }},
            {
                $group: {
                    _id: '$_id.image',
                    scores: { $push: { score: "$_id.score", sum: "$sum"}}
                }
            }
        ]).toArray();

        const mapped = result.map((scored) => {
            return {
                uuid: scored._id,
                scores: scored.scores.reduce((a, b) => ({ ...a, [b.score]: b.sum }), {})
            }

        })

        return mapped;
    }

    send(res, 404, 'Not Found')
}