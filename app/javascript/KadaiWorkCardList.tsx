import React, { useEffect, useState } from 'react';
import { Col, Row } from 'react-bootstrap';
import { Flipper, Flipped } from 'react-flip-toolkit';
import KadaiWorkCardListSortingMethodSelect from 'KadaiWorkCardListSortingMethodSelect';
import LoadingSpinner from 'LoadingSpinner';
import WorkCard from 'WorkCard';
import { User, Work } from 'types';

type Props = {
  jsonUrl: string;
  defaultSortingMethod: string;
  currentUser?: User;
};

const KadaiWorkCardList: React.FC<Props> = ({ jsonUrl, defaultSortingMethod = 'default', currentUser }: Props) => {
  const [sortingMethod, setSortingMethod] = useState<string>(defaultSortingMethod);
  const [works, setWorks] = useState<Work[] | null>(null);

  useEffect(() => {
    (async () => {
      const response = await fetch(jsonUrl);
      if (response.ok) {
        const works = await response.json();
        setWorks(works);
      } else {
        throw new Error(`Failed to request GET ${jsonUrl} (${response.status} ${response.statusText})`);
      }
    })();
  }, [jsonUrl]);

  if (works === null) {
    return <LoadingSpinner />;
  }

  if (sortingMethod === 'genron_sf') {
    works.sort(compareByGenronSf);
  } else if (sortingMethod === 'genron_sf_student') {
    works.sort(compareByGenronSfStudent);
  } else {
    works.sort(compareByVotesCount);
  }

  return (
    <Flipper flipKey={works.map((work) => work.id).join()}>
      <Row className="mb-3">
        <Col xs="auto" className="ms-auto">
          <KadaiWorkCardListSortingMethodSelect
            sortingMethod={sortingMethod}
            handleSortingMethodUpdated={setSortingMethod}
            isLoggedIn={!!currentUser}
          />
        </Col>
      </Row>
      <Row xs={1} md={2} xl={3}>
        {works.map((work) => (
          <Flipped key={work.id} flipId={work.id}>
            <Col>
              <WorkCard work={work} currentUser={currentUser} />
            </Col>
          </Flipped>
        ))}
      </Row>
    </Flipper>
  );
};

function compareByVotesCount(a: Work, b: Work): number {
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

    if (a.student.genron_sf_id && b.student.genron_sf_id) {
      if (a.student.genron_sf_id < b.student.genron_sf_id) {
        return -1;
      } else if (a.student.genron_sf_id > b.student.genron_sf_id) {
        return 1;
      }
    }
  }

  if (a.id < b.id) {
    return -1;
  } else {
    return 1;
  }
}

function compareByGenronSfStudent(a: Work, b: Work): number {
  if (a.genron_sf_id && !b.genron_sf_id) {
    return -1;
  } else if (!a.genron_sf_id && b.genron_sf_id) {
    return 1;
  }

  if (a.genron_sf_id && b.genron_sf_id && a.student.genron_sf_id && b.student.genron_sf_id) {
    if (a.student.genron_sf_id < b.student.genron_sf_id) {
      return -1;
    } else if (a.student.genron_sf_id > b.student.genron_sf_id) {
      return 1;
    }
  }

  if (a.id < b.id) {
    return -1;
  } else {
    return 1;
  }
}

export default KadaiWorkCardList;
