import React, { useEffect, useState } from 'react';
import { Col, Row } from 'react-bootstrap';
import WorkCard from 'WorkCard';
import LoadingSpinner from 'LoadingSpinner';
import { User, Work } from 'types';

type Props = {
  jsonUrl: string;
  currentUser?: User;
};

const StudentWorkCardList: React.FC<Props> = ({ jsonUrl, currentUser }: Props) => {
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

  works.sort((a, b) => {
    if (!a.kadai || !b.kadai) {
      throw Error('Unexpected status: work does not have kadai');
    }

    if (a.kadai.year > b.kadai.year) {
      return -1;
    } else if (a.kadai.year < b.kadai.year) {
      return 1;
    }

    if (a.kadai.round > b.kadai.round) {
      return -1;
    } else if (a.kadai.round < b.kadai.round) {
      return 1;
    }

    if (a.id > b.id) {
      return -1;
    } else {
      return 1;
    }
  });

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

export default StudentWorkCardList;
