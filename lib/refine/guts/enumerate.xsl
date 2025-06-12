<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:template match="*" mode="dtea:enumerate.isReferrable" as="xs:boolean">
        <xsl:value-of select="false()"/>
    </xsl:template>

    <xsl:template match="*[*[dtea:isTitle(.)]]" mode="dtea:enumerate.isReferrable" as="xs:boolean">
        <xsl:value-of select="true()"/>
    </xsl:template>

    <xsl:function name="dtea:enumerate.isReferrable" as="xs:boolean">

        <xsl:param name="element"/>

        <xsl:apply-templates select="$element" mode="dtea:enumerate.isReferrable"/>

    </xsl:function>


    <xsl:template match="*" mode="dtea:enumerate">
        <xsl:apply-templates select="*" mode="dtea:enumerate"/>
    </xsl:template>


    <xsl:template match="*[dtea:enumerate.isReferrable(.)]" mode="dtea:enumerate">

        <dtea:numref>

            <xsl:attribute name="idref" select="@id"/>
            
            <xsl:attribute name="topicId" select="dtea:topicId(.)"/>

            <xsl:copy-of select="@class"/>

            <xsl:copy-of select="xat:usefulAttr('exposedId', dtea:crossref.exposedId(.))"/>

            <xsl:attribute name="uniquePageFileNameBase"
                select="dtea:flatten.uniquePageFileNameBase(.)"/> 

            <dtea:exposedContent>
                <xsl:apply-templates select="." mode="dtea:crossref.exposedContent"/>
            </dtea:exposedContent>

        </dtea:numref>

        <xsl:apply-templates select="*" mode="dtea:enumerate"/>

    </xsl:template>


    <xsl:template match="*[dtea:isMap(.)]" mode="dtea:enumerate">

        <xsl:copy>

            <xsl:copy-of select="@*"/>

            <dtea:numrefs>
                <xsl:apply-templates select="*" mode="dtea:enumerate"/>
            </dtea:numrefs>

            <xsl:copy-of select="*"/>

        </xsl:copy>

    </xsl:template>


    <xsl:function name="dtea:enumerate.entryById">

        <xsl:param name="id"/>
        <xsl:param name="docRoot"/>

        <xsl:copy-of select="$docRoot/*/dtea:numrefs/dtea:numref[@idref = $id]"/>

    </xsl:function>


    <xsl:function name="dtea:flatten.uniquePageFileNameBaseById">

        <xsl:param name="id"/>
        <xsl:param name="docRoot"/>

        <xsl:variable name="fastUniquePageFileNameBase"
            select="dtea:enumerate.entryById($id, $docRoot)/@uniquePageFileNameBase"/>

        <xsl:choose>
            
            <xsl:when test="$fastUniquePageFileNameBase != ''">
                <xsl:value-of select="$fastUniquePageFileNameBase"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="dtea:flatten.uniquePageFileNameBase($docRoot//*[@id = $id])"/>
            </xsl:otherwise>
            
        </xsl:choose>

    </xsl:function>
    
    
    <!-- The ID of the topic to which the target of a cross-reference belongs to -->
    
    <xsl:template match="*[dtea:isCrossref(.)]" mode="dtea:crossref.targetTopicId">
        
        <xsl:choose>
            
            <xsl:when test="contains(@href, '/')">
                <xsl:value-of select="substring-after(substring-before(@href, '/'), '#')"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="substring-after(@href, '#')"/>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:function name="dtea:crossref.targetTopicId">
        
        <xsl:param name="crossref"/>
        
        <xsl:apply-templates select="$crossref" mode="dtea:crossref.targetTopicId"/>
        
    </xsl:function>

</xsl:stylesheet>
