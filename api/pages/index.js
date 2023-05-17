const fs = require('fs');


const findFiles = function (dir, pattern) {
  var results = [];
  fs.readdirSync('../public/json/').forEach(function (file) {
      file = path.resolve(dir, file);
      var stat = fs.statSync(file);
      if (stat.isDirectory()) {
          results = results.concat(findFile(file, pattern));
      }
      if (stat.isFile() && file.endsWith(pattern)) {
          results.push(file);
      }
  });
  return results;
};

export default function Index() {
  const heroPost = edges[0]?.node

  return (
    <Layout preview={preview}>
      <Head>
        <title>{`Next.js Blog Example with ${CMS_NAME}`}</title>
      </Head>
      <Container>
        <Intro />
        {heroPost && (
          <HeroPost
            title={heroPost.title}
            coverImage={heroPost.featuredImage}
            date={heroPost.date}
            author={heroPost.author}
            slug={heroPost.slug}
            excerpt={heroPost.excerpt}
          />
        )}
        {morePosts.length > 0 && <MoreStories posts={morePosts} />}
      </Container>
    </Layout>
  )
}