import React, { FormEventHandler, useEffect, useState } from 'react';
import { Col, FormSelect, Row } from 'react-bootstrap';
import { Flipper, Flipped } from 'react-flip-toolkit';
import WorkCard from 'WorkCard';
import LoadingSpinner from 'LoadingSpinner';
import { User, Work } from 'types';

type Props = {
  jsonUrl: string;
  sortingMethod: string;
  currentUser?: User;
};

const KadaiWorkCardList: React.FC<Props> = ({ jsonUrl, sortingMethod = 'default', currentUser }: Props) => {
  const [sortingMethodName, setSortingMethodName] = useState<string>(sortingMethod);
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

  if (sortingMethodName === 'genron_sf') {
    works.sort(compareByGenronSf);
  } else if (sortingMethodName === 'genron_sf_student') {
    works.sort(compareByGenronSfStudent);
  } else {
    works.sort(compareByVotesCount);
  }

  const handleOnChange: FormEventHandler<HTMLSelectElement> = (event) => {
    setSortingMethodName(event.currentTarget.value);
  };

  return (
    <Flipper flipKey={works.map((work) => work.id).join()}>
      <Row className="mb-3">
        <Col xs="auto" className="ms-auto">
          <FormSelect size="sm" onChange={handleOnChange}>
            <option value="default" selected={sortingMethod === 'default'}>
              裏SF創作講座順
            </option>
            <option value="genron_sf" selected={sortingMethod === 'genron_sf'}>
              超・SF作家育成サイト順
            </option>
            <option value="genron_sf_student" selected={sortingMethod === 'genron_sf_student'}>
              超・SF作家育成サイト受講生順
            </option>
          </FormSelect>
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
