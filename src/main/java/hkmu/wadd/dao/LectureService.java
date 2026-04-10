package hkmu.wadd.dao;

import hkmu.wadd.exception.AttachmentNotFound;
import hkmu.wadd.exception.LectureNotFound;
import hkmu.wadd.model.Attachment;
import hkmu.wadd.model.Comment;
import hkmu.wadd.model.Lecture;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
public class LectureService {

    @Resource
    private LectureRepository lectureRepo;

    @Resource
    private AttachmentRepository attachmentRepo;

    @Resource
    private CommentRepository commentRepo;

    @Transactional
    public List<Lecture> getLectures() {
        return lectureRepo.findAll();
    }

    @Transactional
    public Lecture getLecture(long id) throws LectureNotFound {
        Lecture lecture = lectureRepo.findById(id).orElse(null);
        if (lecture == null)
            throw new LectureNotFound(id);
        return lecture;
    }

    @Transactional
    public long createLecture(String title, String summary,
            List<MultipartFile> attachments) throws IOException {
        Lecture lecture = new Lecture();
        lecture.setTitle(title);
        lecture.setSummary(summary);
        for (MultipartFile file : attachments) {
            if (!file.isEmpty()) {
                Attachment a = new Attachment();
                a.setName(file.getOriginalFilename());
                a.setMimeContentType(file.getContentType());
                a.setContents(file.getBytes());
                a.setLecture(lecture);
                lecture.getAttachments().add(a);
            }
        }
        lectureRepo.save(lecture);
        return lecture.getId();
    }

    @Transactional
    public void updateLecture(long id, String title, String summary,
            List<MultipartFile> attachments)
            throws LectureNotFound, IOException {
        Lecture lecture = getLecture(id);
        lecture.setTitle(title);
        lecture.setSummary(summary);
        for (MultipartFile file : attachments) {
            if (!file.isEmpty()) {
                Attachment a = new Attachment();
                a.setName(file.getOriginalFilename());
                a.setMimeContentType(file.getContentType());
                a.setContents(file.getBytes());
                a.setLecture(lecture);
                lecture.getAttachments().add(a);
            }
        }
        lectureRepo.save(lecture);
    }

    @Transactional
    public void delete(long id) throws LectureNotFound {
        lectureRepo.delete(getLecture(id));
    }

    @Transactional
    public Attachment getAttachment(long lectureId, UUID attachmentId)
            throws LectureNotFound, AttachmentNotFound {
        Lecture lecture = getLecture(lectureId);
        return lecture.getAttachments().stream()
                .filter(a -> a.getId().equals(attachmentId))
                .findFirst()
                .orElseThrow(() -> new AttachmentNotFound(attachmentId));
    }

    @Transactional
    public void deleteAttachment(long lectureId, UUID attachmentId)
            throws LectureNotFound, AttachmentNotFound {
        Lecture lecture = getLecture(lectureId);
        Attachment attachment = getAttachment(lectureId, attachmentId);
        lecture.getAttachments().remove(attachment);
        lectureRepo.save(lecture);
    }

    @Transactional
    public void addComment(long lectureId, String username, String content)
            throws LectureNotFound {
        Lecture lecture = getLecture(lectureId);
        Comment comment = new Comment();
        comment.setUsername(username);
        comment.setContent(content);
        comment.setLecture(lecture);
        lecture.getComments().add(comment);
        lectureRepo.save(lecture);
    }


    @Transactional
    public void deleteComment(long lectureId, long commentId) throws LectureNotFound {
        Lecture lecture = getLecture(lectureId);        
        lecture.getComments().removeIf(c -> c.getId() == commentId);
        lectureRepo.save(lecture);
    }

}
