const Parser = require('rss-parser');
const { db } = require('./firebaseAdmin');
const parser = new Parser({
    customFields: {
        item: [
            ['content:encoded', 'contentEncoded'],
            ['media:content', 'mediaContent']
        ]
    }
});

async function syncEitanRecipes() {
    console.log('🔄 Syncing Eitan Latest Recipes...');
    try {
        const feed = await parser.parseURL('https://www.eitanbernath.com/recipes/feed/');

        const recipesCollection = db.collection('recipes');
        let count = 0;

        for (const item of feed.items) {
            // Find image URL
            // Try mediaContent first, then look into contentEncoded/description for <img> tags
            let imageUrl = '';
            if (item.mediaContent && item.mediaContent.$) {
                imageUrl = item.mediaContent.$.url;
            } else if (item.contentEncoded) {
                const imgMatch = item.contentEncoded.match(/<img[^>]+src="([^">]+)"/);
                if (imgMatch) imageUrl = imgMatch[1];
            }

            if (!imageUrl && item.content) {
                const imgMatch = item.content.match(/src="([^">]+)"/);
                if (imgMatch) imageUrl = imgMatch[1];
            }

            // Fallback if still no image
            if (!imageUrl) imageUrl = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600';

            const recipeId = 'eitan_' + item.guid?.split('?p=')[1] || item.title.replace(/\s+/g, '_').toLowerCase();

            // Check if it already exists to avoid duplicates
            // We use the title or a custom ID to check
            const query = await recipesCollection.where('externalUrl', '==', item.link).limit(1).get();

            const recipeData = {
                title: item.title,
                author: 'Eitan Bernath',
                description: item.contentSnippet?.substring(0, 150) + '...',
                coverImage: imageUrl,
                cookTime: 'External', // We don't have prep/cook time in the feed easily
                difficulty: 'Medium',
                externalUrl: item.link,
                isExternal: true,
                category: 'Latest',
                createdAt: new Date(item.pubDate) || new Date(),
            };

            if (query.empty) {
                await recipesCollection.add(recipeData);
                count++;
            }
        }

        console.log(`✅ Sync Complete! Added ${count} new recipes.`);
        return count;
    } catch (error) {
        console.error('❌ Error syncing Eitan recipes:', error.message);
        throw error;
    }
}

module.exports = { syncEitanRecipes };
