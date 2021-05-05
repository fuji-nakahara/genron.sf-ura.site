import React, { useEffect, useState } from 'react';
import { Col, Row } from 'react-bootstrap';
import WorkCard from 'WorkCard';
import LoadingSpinner from 'LoadingSpinner';
import { User, Work } from 'types';

type Props = {
  jsonUrl: string;
  currentUser?: User;
};

const WorkCardList: React.FC<Props> = ({ jsonUrl, currentUser }: Props) => {
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

export default WorkCardList;
