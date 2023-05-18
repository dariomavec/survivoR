import { join } from 'path'
const fs = require('fs');
import Link from 'next/link';
import Head from "next/head";

// getStaticProps only runs in the Node side, so it is safe
// to use libraries from Node here
export async function getStaticProps() {
  const dataDir = join(process.cwd(), 'public/json/')
  const dataSets = fs.readdirSync(dataDir).map(
    (dataSet) => dataSet.replace(/\.json/g, "")
  );

  const mans = dataSets.map(
    (dataset) => fs.readFileSync(join(process.cwd(), 'public/man/', dataset + ".html"), 'utf8')
  );

  return {
    props: {
      dataSets: dataSets,
      mans: mans
    }
  };
}

export default function Index({ dataSets, mans }) {
  return (
    <>
    <Head>
      <meta name="viewport" content="width=device-width, initial-scale=1" />
    </Head>

    {<div class = "row">
      {mans.map((man, idx) => (
        <div class="col-sm-3" style = {{ padding: "16px" }} > 
          <div class = "card" key = {idx} style = {{ 
            height: "500px", 
            overflowY: "scroll"
            }}>
            <div class = "card-body" dangerouslySetInnerHTML={{ __html: man }}></div>
          </div>
        </div>
      ))}
    </div>}
  </>
  )
}