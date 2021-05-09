import React, { useEffect, useState } from 'react';
import { Col, Row } from 'react-bootstrap';
import WorkCard from 'WorkCard';
import LoadingSpinner from 'LoadingSpinner';
import { User, Work } from 'types';

type Props = {
  jsonUrl: string;
  currentUser?: User;
  sortByGenronSf?: boolean;
};

const KadaiWorkCardList: React.FC<Props> = ({ jsonUrl, currentUser, sortByGenronSf }: Props) => {
  const [works, setWorks] = useState<Work[] | null>(null);

  useEffect(() => {
    (async () => {
      const response = await fetch(jsonUrl);
      if (response.ok) {
        const works = await response.json();
        setWorks(works);
      } else {
        throw new Error(`Failed to get data from ${jsonUrl} (${response.status} ${response.statusText})`);
      }
    })();
  }, [jsonUrl]);

  if (works === null) {
    return <LoadingSpinner />;
  }

  if (sortByGenronSf) {
    works.sort(compareByGenronSf);
  } else {
    works.sort(compareByVoteCount);
  }

  return (
    <Row xs={1} md={2} xl={3}>
      {works.map((work) => (
        <Col key={work.id}>
          <WorkCard work={work} currentUser={currentUser} />
        </Col>
      ))}
    </Row>
  );
};

function compareByVoteCount(a: Work, b: Work): number {
  if (a.voters.length > b.voters.length) {
    return -1;
  } else if (a.voters.length < b.voters.length) {
    return 1;
  }

  if (a.id < b.id) {
    return -1;
  } else {
    return 1;
  }
}

function compareByGenronSf(a: Work, b: Work): number {
  if (a.genron_sf_id && !b.genron_sf_id) {
    return -1;
  } else if (!a.genron_sf_id && b.genron_sf_id) {
    return 1;
  }

  if (a.genron_sf_id && b.genron_sf_id) {
    if ('score' in a && 'score' in b) {
      if (a.prize && !b.prize) {
        return -1;
      } else if (!a.prize && b.prize) {
        return 1;
      }

      if (a.prize && b.prize) {
        if (a.prize.position < b.prize.position) {
          return -1;
        } else if (a.prize.position > b.prize.position) {
          return 1;
        }
      }

      if (a.score > b.score) {
        return -1;
      } else if (a.score < b.score) {
        return 1;
      }
    }

    if (a.selected && !b.selected) {
      return -1;
    } else if (!a.selected && b.selected) {
      return 1;
    }

    if (a.genron_sf_id < b.genron_sf_id) {
      return -1;
    } else if (a.genron_sf_id > b.genron_sf_id) {
      return 1;
    }
  }

  return 0;
}

export default KadaiWorkCardList;
